//
//  Home.swift
//  PhotosApp
//
//  Created by 엄기철 on 5/10/24.
//

import SwiftUI

struct Home: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Text("Recents")
                        .font(.largeTitle.bold())
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 3),
                                       count: 3),
                        spacing: 3) {
                            ForEach($bindableCoordinator.items) { $item in
                                GridImageView(item)
                                    .id(item.id)
                                    .didFrameChange { frame, bounds in
                                        let minY = frame.minY
                                        let maxY = frame.maxY
                                        let height = bounds.height
                                        
                                        if maxY < 0 || minY > height {
                                            item.appeared = false
                                        } else {
                                            item.appeared = true
                                        }
                                    }
                                    .onDisappear {
                                        item.appeared = false
                                    }
                                    .onTapGesture {
                                        coordinator.selectedItem = item
                                    }
                            }
                        }
                        .padding(.vertical, 15)
                }
            }
            .onChange(of: coordinator.selectedItem) { oldValue, newValue in
                if let item = coordinator.items.first(where: { $0.id == newValue?.id }),
                   !item.appeared {
                    /// Scroll to this item, as this is not visible on the screen
                    reader.scrollTo(item.id, anchor: .bottom)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    /// Image View For Grid
    @ViewBuilder
    func GridImageView(_ itme: Item) -> some View {
        GeometryReader {
            let size = $0.size
            
            /// To animate the layer, we need both the source and destination anchors (Frame to animate from source to destination, which can be obtained through Anchor Preferences. Let's attach the source and destination anchors at the appropriate places.
            Rectangle()
                .fill(.clear)
                .anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
                    return [itme.id + "SOURCE" : anchor]
                })
            
            if let previewImage = itme.previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(coordinator.selectedItem?.id == itme.id ? 0 : 1)
            }
        }
        .frame(height: 130)
        .contentShape(.rect)
    }
}

#Preview {
    ContentView()
}
