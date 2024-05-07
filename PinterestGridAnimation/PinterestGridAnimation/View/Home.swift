//
//  Home.swift
//  PinterestGridAnimation
//
//  Created by 엄기철 on 5/7/24.
//

import SwiftUI

struct Home: View {
    /// UI Properties
    var coordinator: UICoordinator = .init()
    @State private var posts: [Item] = sampleImages
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 15) {
                Text("Welcome Back!")
                    .font(.largeTitle.bold())
                    .padding(.vertical, 10)
                
                /// Grid Image View
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
                    ForEach(posts) { post in
                        PostCardView(post)
                    }
                }
            }
            .padding(15)
            .background(ScrollViewExtractor {
                coordinator.scrollView = $0
            })
        }
        .opacity(coordinator.hideRootView ? 0 : 1)
        .scrollDisabled(coordinator.hideRootView)
        .allowsHitTesting(!coordinator.hideRootView)
        .overlay {
            Detail()
                .environment(coordinator)
                .allowsHitTesting(coordinator.hideLayer)
        }
    }
    
    /// Post Card View
    @ViewBuilder
    func PostCardView(_ post: Item) -> some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            ImageView(post: post)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect(cornerRadius: 10))
                .onTapGesture {
                    coordinator.toogleView(show: true, frame: frame, post: post)
                }
        }
        .frame(height: 180)
    }
}

#Preview {
    ContentView()
}
