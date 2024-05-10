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
        ScrollView(.vertical) {
            LazyVGrid(
                columns: Array(repeating: GridItem(spacing: 3),
                               count: 3),
                spacing: 3) {
                    ForEach(coordinator.items) { item in
                        GridImageView(item)
                            .onTapGesture {
                                coordinator.selectedItem = item
                            }
                    }
                }
                .padding(.vertical, 15)
        }
        .navigationTitle("Recents")
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
