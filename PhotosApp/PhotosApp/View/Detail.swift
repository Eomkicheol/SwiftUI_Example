//
//  Detail.swift
//  PhotosApp
//
//  Created by 엄기철 on 5/10/24.
//

import SwiftUI

struct Detail: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
            GeometryReader {
                let size = $0.size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(coordinator.items) { item in
                            /// Image View
                            ImageView(item, size: size)
                        }
                    }
                    .scrollTargetLayout()
                }
                /// Making it as a Paging View
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .scrollPosition(
                    id: .init(
                        get: { return coordinator.detailScrollPosition },
                        set: { coordinator.detailScrollPosition = $0 }
                    )
                )
                .onChange(of: coordinator.detailScrollPosition, { oldValue, newValue in
                    coordinator.didDetailPageChanged()
                })
                .background {
                    /// We can just add the destination anchor as a background to the scrollview, which likewise occupies the full available space, because every item in the destination scrollview takes up the entire available space.
                    if let selectedItem = coordinator.selectedItem {
                        Rectangle()
                            .fill(.clear)
                            .anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
                                return [selectedItem.id + "DEST" : anchor]
                            })
                    }
                }
            }
        }
        .opacity(coordinator.showDetailView ? 1 : 0)
        .onAppear {
            ///This will ensure that the detail view loads and initiates the layer animation. The reason it's not toggled when the item is tapped in Home View is that occasionally, the destination view might not be loaded. In that scenario, the destination anchor will be nil and the layer will not be animated.
            coordinator.toggleView(show: true)
        }
    }
    
    @ViewBuilder
    func ImageView(_ item: Item, size: CGSize) -> some View {
        
        if let image = item.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .clipped()
                .contentShape(.rect)
        }
        
    }
    
    /// Custom Navigation Bar
    @ViewBuilder
    func NavigationBar() -> some View {
        HStack {
            Button {
                coordinator.toggleView(show: false)
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                    Text("Back")
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .padding(10)
                    .background(.bar, in: .circle)
            }
        }
        .padding([.top, .horizontal], 15)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .offset(y: coordinator.showDetailView ? 0 : -120)
        .animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
    }
}

#Preview {
    ContentView()
}
