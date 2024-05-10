//
//  UICoordinator.swift
//  PhotosApp
//
//  Created by 엄기철 on 5/10/24.
//

import SwiftUI

@Observable
class UICoordinator {
    /// I'm using the default image as the preview image as well, but you may make an optimized version of the image if you'd like it to show up in grid view and paging indicators, for example.
    var items: [Item] = sampleItems.compactMap {
        Item(title: $0.title, image: $0.image, previewImage: $0.image)
    }
    
    /// Animation Properties
    var selectedItem: Item?
    var animateView: Bool = false
    var showDetailView: Bool = false
    /// Since the ID of the Item Model value type is a string, l'm using it as well to observe the location of the paging view.
    var detailScrollPosition: String?
    
    func toggleView(show: Bool) {
        if show {
            /// Since the ID of the Item Model value type is a string, l'm using it as well to observe the location of the paging view.
            detailScrollPosition = selectedItem?.id
            withAnimation(.easeOut(duration: 0.8), completionCriteria: .removed) {
                animateView = true
            } completion: {
                /// Let's hide the layer view and unhide the detail view when the layer animation is finished.
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.8), completionCriteria: .removed) {
                animateView = false
            } completion: {
                self.resetAnimationProperties()
            }

            
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
    }
    
    func didDetailPageChanged() {
        if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
            selectedItem = updatedItem
        }
    }
}


