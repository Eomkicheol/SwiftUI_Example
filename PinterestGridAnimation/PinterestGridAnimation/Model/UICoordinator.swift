//
//  UICoordinator.swift
//  PinterestGridAnimation
//
//  Created by 엄기철 on 5/7/24.
//

import Foundation
import SwiftUI


@Observable
class UICoordinator {
    /// Shared View Properties between Home and Detail View
    ///1. I'II extract the SwiftUl scrollview and save it here to take a screenshot of the visible region for animation purposes.
    ///2. Rect will be used to save the tapped post's View Rect for scaling calculations.
    var scrollView: UIScrollView = .init(frame: .zero)
    var rect: CGRect = .zero
    ///As you can see, the edge pictures have been clipped because we just got a snapshot of the visible region.
    ///To fix this, we need to place a hero view at the exact source position (Grid) and extend it to meet the screen width.
    /// (Later, we may utilize this view as the detail view header and slide out when the detail view is scrolled.)
    var selectedItem: Item?
    /// Animation Layer Properties
    var animationLayer: UIImage?
    var animateView: Bool = false
    var hideLayer: Bool = false
    /// Root View Properties
    var hideRootView: Bool = false
    /// Detail View Properties
    var headerOffset: CGFloat = .zero
    
    func createVisibleAreaSnapshot() {
        /// This will capture a screenshot of the scrollview's visible region, not the complete scroll content.
        let renderer = UIGraphicsImageRenderer(size: scrollView.bounds.size)
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y)
            scrollView.layer.render(in: ctx.cgContext)
        }
        animationLayer = image
    }
    
    func toogleView(show: Bool, frame: CGRect, post: Item) {
        if show {
            selectedItem = post
            /// Storing View's Rect
            rect = frame
            /// Generating Scrollview's Visible area Snapshot
            createVisibleAreaSnapshot()
            hideRootView = true
            /// Animating View
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = true
            } completion: {
                /// Once the detail view expands, I will hide the animation layer and enable detail view interaction (this will be reversed when the closing animation begins).
                self.hideLayer = true
            }
        } else {
            /// Closing View
            hideLayer = false
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = false
            } completion: {
                DispatchQueue.main.async {
                    /// Resetting Properties
                    self.resetAnimationProperties()
                }
            }
            
        }
    }
    
    private func resetAnimationProperties() {
        headerOffset = 0
        hideRootView = false
        selectedItem = nil
        animationLayer = nil
    }
}


struct ScrollViewExtractor: UIViewRepresentable {
    var result: (UIScrollView) -> ()
    ///This will extract the UlKit ScrollView from the SwiftUl ScrollView.
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.async {
            if let scrollView = view.superview?.superview?.superview as? UIScrollView {
                result(scrollView)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
