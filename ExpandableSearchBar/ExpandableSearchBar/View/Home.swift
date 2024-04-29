//
//  Home.swift
//  ExpandableSearchBar
//
//  Created by 엄기철 on 4/29/24.
//

import SwiftUI

struct Home: View {
    
    /// View Properties
    @State private var searchText: String = ""
    @FocusState private var isSearching: Bool
    @State private var activeTab: Tab = .all
    @Environment(\.colorScheme) private var scheme
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                SummyMessagesView()
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                ExpandableNavigationBar()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
        }
        .scrollTargetBehavior(CustomScrollTargetBehaviour())
        .background(.gray.opacity(0.15))
        .contentMargins(.top, 190, for: .scrollIndicators)
    }
    
    /// Expandable NavigationBar
    @ViewBuilder
    func ExpandableNavigationBar(_ title: String = "Message") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollviewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + (max(min(minY / scrollviewHeight, 1), 0) * 0.5) : 1
            /*
             As we have built the navigation bar
             to be expandable when it's scrolled,
             we can just apply some small tweaks
             to extend the navigation bar when
             the search textfield is active.
             */
            let progress = isSearching ? 1 : max(min(-minY / 70, 1), 0)
            VStack(spacing: 10) {
                //Title
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                //SearchBar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    
                    TextField("Search Conversations", text: $searchText)
                        .focused($isSearching)
                    
                    if isSearching {
                        Button(action: {
                            isSearching = false
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        })
                        .transition(.asymmetric(insertion: .push(from: .bottom), 
                                                removal: .push(from: .top)))
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 15 - (progress * 15))
                .frame(minHeight: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25 - (progress * 25))
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 65)
                        .padding(.horizontal, -progress * 15)
                }
                
                /// Custom Segmented Picker
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(Tab.allCases, id:\.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (scheme == .dark ? .black : .white) : Color.primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if activeTab == tab {
                                         Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 50)
            
            
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            /*
             Making the navigation bar always
             appear at the top while the
             search bar is active.
             */
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
            
        }
        .frame(height: 190) /// Because the components within the navigation bar nave fixed heights, 190 is the sum of all of them.
        .padding(.bottom, 10)
        .padding(.bottom, isSearching ? -65 : 0)
    }
    
    /// Dummy Messages View
    @ViewBuilder
    func SummyMessagesView() -> some View {
        ForEach(0..<20, id: \.self) { _ in
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()
                        .frame(width: 150, height: 8)
                    
                    Rectangle()
                        .frame( height: 8)
                    
                    Rectangle()
                        .frame(width: 80, height: 8)
                }
                .foregroundStyle(.gray.opacity(0.4))
                .padding(.horizontal, 15)
            }
        }
    }
}

/*
 The view may appear uneven if the
 user stops scrolling in the middle of
 a scroll transition. In certain circumstances,
 we may use the new Scroll target Behaviour
 to detect when the dragging is complete,
 allowing us to either reset the transition
 to its start phase or finish it based on
 the end target value.
 */

struct CustomScrollTargetBehaviour: ScrollTargetBehavior{
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}

#Preview {
    ContentView()
}
