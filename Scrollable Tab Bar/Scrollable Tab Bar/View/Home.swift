//
//  Home.swift
//  Scrollable Tab Bar
//
//  Created by 엄기철 on 4/21/24.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var tabs: [TabModel] = [
        .init(id: TabModel.Tab.research),
        .init(id: TabModel.Tab.deployment),
        .init(id: TabModel.Tab.analytics),
        .init(id: TabModel.Tab.audience),
        .init(id: TabModel.Tab.privacy),
    ]
    
    @State private var activeTab: TabModel.Tab = .research
    @State private var tabBarScrollState: TabModel.Tab?
    @State private var mainViewScrollState: TabModel.Tab?
    @State private var progress: CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            CustomTabBar()
            
            //Main View
            GeometryReader {
                let size = $0.size
                
                /*iOS 17에서는 이제 페이징 뷰를 생성할 수 있습니다.
                 그 어느 때보다 더 쉽게. 다음이 중요합니다.
                 스크롤뷰 내의 각 탭 보기에 유의하세요.
                 전체 화면 너비여야 합니다. 그렇지 않으면 페이징이 수행됩니다.
                 제대로 작동하지 않습니다.*/
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        // YOUR INDIVIDUAL TAB VIEWS
                        ForEach(tabs) { tab in
                            Text(tab.id.rawValue)
                                .frame(width: size.width, height:  size.height)
                                .contentShape(.rect)
                            
                        }
                    }
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / size.width
                    }
                }
                /*스크롤이 있다는 점에 주목하는 것이 중요합니다.
                 위치는 정확한 데이터와 일치해야 합니다.
                 ForEach에 제공된 ID 유형
                 루프, 이 예에서 ID는 탭입니다.
                 열거형, 따라서 mainViewScrollState
                 속성도 탭 데이터 유형입니다.*/
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onChange(of: mainViewScrollState) { oldValue, newValue in
                    if let newValue {
                        withAnimation(.snappy) {
                            tabBarScrollState = newValue
                            activeTab = newValue
                        }
                    }
                }
            }
        }
    }
    
    // Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
            
            Spacer(minLength: 0)
            
            //Butons
            Button("", systemImage: "plus.circle") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            Button("", systemImage: "bell") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            // Profile Button
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(.pic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(.circle)
            })
            
        }
        .padding(15)
        // Divider
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
        }
    }
    
    // Dynamic Scrollable Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $tab in
                    Button(action: {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    }) {
                        Text(tab.id.rawValue)
                            .padding(12)
                            .foregroundStyle(activeTab ==  tab.id ? Color.primary : .gray)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in
            
        }), anchor: .center)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                
                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
                let outputRange = tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabs.compactMap { return $0.minX }
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    Home()
}
