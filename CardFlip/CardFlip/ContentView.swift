//
//  ContentView.swift
//  CardFlip
//
//  Created by 엄기철 on 4/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    if showView {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.black.gradient)
                            .transition(.reverseFlip)
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.red.gradient)
                            .transition(.flip)
                    }
                }
                .frame(width: 200, height: 300)
                
                Button(action: {
                    withAnimation(.bouncy(duration: 2)) {
                        showView.toggle()
                    }
                }, label: {
                    Text(showView ? "Hide" : "Reveal")
                })
                .padding(.top, 30)
            }
            .navigationTitle("Custom Transition")
        }
    }
}

#Preview {
    ContentView()
}

struct FlipTransition: ViewModifier, Animatable {
    var progress: CGFloat = 0
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1.0 : 0) : (progress < 0.5 ? 1.0 : 0))
            .rotation3DEffect(
                .degrees(progress * 180 ),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
}

extension AnyTransition {
    static let flip: AnyTransition = .modifier(active: FlipTransition(progress: -1), identity: FlipTransition())
    
    static let reverseFlip: AnyTransition = .modifier(active: FlipTransition(progress: 1), identity: FlipTransition())
}
