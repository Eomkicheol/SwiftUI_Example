//
//  FloatingButton.swift
//  InteractiveFloatingButton
//
//  Created by 엄기철 on 4/22/24.
//

import SwiftUI

// Custom Button
struct FloatingButton<Label: View>: View {
    
    //Actions
    var buttonSize: CGFloat
    var actions: [FloatingAction]
    var label: (Bool) -> Label
    
    
    init(buttonSize: CGFloat = 50, @FloatingActinBuilder actions: @escaping () -> [FloatingAction], @ViewBuilder label: @escaping (Bool) -> Label) {
        self.buttonSize = buttonSize
        self.actions = actions()
        self.label = label
    }
    
    // View Properties
    @State private var isExpanded: Bool = false
    @State private var dragLocation: CGPoint = .zero
    @State private var selectedAction: FloatingAction?
    @GestureState private var isDragging: Bool = false
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            label(isExpanded)
                .frame(width: buttonSize, height: buttonSize)
                .clipShape(.circle)
        }
        .background {
            ZStack {
                ForEach(actions) { action in
                    ActionView(action)
                }
            }
        }
        .buttonStyle(NoAnimationButtonStyle())
        .gesture(LongPressGesture(minimumDuration: 0.3)
            .onEnded { _ in
                isExpanded = true
            }.sequenced(before: DragGesture().updating($isDragging, body: { _, out, _ in
                out = true
            }).onChanged { value in
                guard isExpanded else { return }
                dragLocation = value.location
            }.onEnded { _ in
                Task {
                    if let selectedAction {
                        isExpanded  = false
                        selectedAction.action()
                    }
                    selectedAction = nil
                    dragLocation = .zero
                }
            })
        )
        .background {
            ZStack {
                ForEach(actions) { action in
                    ActionView(action)
                }
            }
            .frame(width: buttonSize, height: buttonSize)
        }
        .coordinateSpace(.named("FLOATING VIEW"))
        .animation(.snappy(duration: 0.4, extraBounce: 0), value: isExpanded)
    }
    
    // Action View
    @ViewBuilder
    func ActionView(_ action: FloatingAction) -> some View {
        
        Button(action: {
            action.action()
            isExpanded = false
        }, label: {
            Image(systemName: action.symbol)
                .font(action.font)
                .foregroundStyle(action.tint)
                .frame(width: buttonSize, height: buttonSize)
                .background(action.background, in: .circle)
                .clipShape(.circle)
        })
        .buttonStyle(PressableButtonStyle())
        .disabled(!isExpanded)
        .animation(.snappy(duration: 0.3, extraBounce: 0)) { content in
            content
                .scaleEffect(selectedAction?.id == action.id ? 1.15 : 1)
        }
        .background {
            GeometryReader {
                let rect = $0.frame(in: .named("FLOATING VIEW"))
                
                Color.clear
                    .onChange(of: dragLocation) { oldValue, newValue in
                        if isExpanded && isDragging {
                            /// 드래그 위치가 액션의 렉 내부에 있는지 확인하기
                            if rect.contains(newValue) {
                                /// 사용자가 이 동작을 누르고 있습니다.
                                selectedAction = action
                                
                            } else {
                                /// 정류장 밖으로 나갔는지 확인
                                if selectedAction?.id == action.id && !rect.contains(newValue) {
                                    selectedAction = nil
                                }
                                
                            }
                        }
                        
                    }
            }
        }
        .rotationEffect(.init(degrees: progress(action) * -90))
        .offset(x: isExpanded ? -offset / 2 : 0)
        .rotationEffect(.init(degrees: progress(action) * 90))
    }
    
    private var offset: CGFloat {
        let buttonSize = buttonSize + 10
        return Double(actions.count) * (actions.count == 1 ? buttonSize * 2 : (actions.count == 2 ? buttonSize * 1.25 : buttonSize))
    }
    
    private func progress(_ action: FloatingAction) -> CGFloat {
        let index = CGFloat(actions.firstIndex(where: { $0.id == action.id}) ?? 0)
        return actions.count == 1 ? 1 : (index / CGFloat(actions.count - 1))
    }
}

// Custom Button
fileprivate struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

fileprivate struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.snappy(duration: 0.3, extraBounce: 0), value:    configuration.isPressed)
    }
}

struct FloatingAction: Identifiable {
    private(set) var id: UUID = .init()
    var symbol: String
    var font: Font = .title3
    var tint: Color = .white
    var background: Color = .black
    var action: () -> ()
}

// 결과 빌더를 사용하여 작업 배열을 가져오는 빌더와 같은 SwiftUI 보기
@resultBuilder
struct FloatingActinBuilder {
    static func buildBlock(_ components: FloatingAction...) -> [FloatingAction] {
        return components.compactMap { $0 }
    }
}


#Preview {
    ContentView()
}
