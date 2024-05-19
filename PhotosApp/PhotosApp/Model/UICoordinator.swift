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
    var detailIndicatorPosition: String?
    /// Gesture Properties
    var offset: CGSize = .zero
    var dragProgress: CGFloat = 0
    
    func didDetailPageChanged() {
        if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
            selectedItem = updatedItem
            /// Updating Indicator Position
            withAnimation(.easeInOut(duration: 0.1)) {
                detailIndicatorPosition = updatedItem.id
            }
        }
    }
    
    func didDetailIndicatorPageChanged() {
        if let updatedItem = items.first(where: { $0.id == detailIndicatorPosition }) {
            selectedItem = updatedItem
            /// Updating Detail Paging View As Well
            detailScrollPosition = updatedItem.id
        }
    }
    
    func toggleView(show: Bool) {
        if show {
            /// Since the ID of the Item Model value type is a string, l'm using it as well to observe the location of the paging view.
            detailScrollPosition = selectedItem?.id
            /// This ensures that the bottom  carousel always starts with the selected item.
            detailIndicatorPosition = selectedItem?.id
            withAnimation(.easeOut(duration: 0.2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                /// Let's hide the layer view and unhide the detail view when the layer animation is finished.
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
        offset = .zero
        dragProgress = 0
        detailIndicatorPosition = nil
    }
    
    
}
