//
//  Detail.swift
//  PinterestGridAnimation
//
//  Created by 엄기철 on 5/7/24.
//

import SwiftUI

struct Detail: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        GeometryReader {
            let size = $0.size
            /// This sets the anchorX location of the scaling, if the anchor is less than 0.5, it is on the leading side, Otherwise, it is on the trailing side, Keep in mind that I am building this animation to support only two columns in a grid.
            let animateView = coordinator.animateView
            let hideLayer = coordinator.hideLayer
            let rect = coordinator.rect
            
            let anchorX = (coordinator.rect.minX / size.width) > 0.5 ? 1.0 : 0.0
            
            /// This value will be scaled to meet the screen's whole width.
            let scale =  size.width / coordinator.rect.width
            
            /// 15 - Horizontal Padding.
            let offsetX = animateView ? (anchorX > 0.5 ? 15 : -15) * scale : 0
            let offsetY = animateView ? -coordinator.rect.minY * scale : 0
            
            let detailHeight: CGFloat = rect.height * scale
            ///Because the hero view is disabled for user interaction, scrollview permits scrolling even when we drag it.
            let scrollContentHeight: CGFloat = size.height - detailHeight
            
            if let image = coordinator.animationLayer, let post = coordinator.selectedItem {
                /// The reason the expanded picture is not properly aligned with the screen is because of padding, We need to apply offset that corresponds with the provided padding, which means if a view horizontal padding 10 implies we need to shift the view 10 * scale. (Since the image has been resized.)
                if !hideLayer {
                    Image(uiImage: image)
                        .scaleEffect(animateView ? scale : 1,
                                     anchor: .init(x: anchorX, y: 0))
                        .offset(x: offsetX, y: offsetY)
                        .offset(y: animateView ? 0 : 1)
                    /// As you can see, even in cases where the edge items display the full-sized image.
                    /// Let's now add an animation to the animation layer that fades out when the view expands.
                        .opacity(animateView ? 0 : 1)
                        .transition(.identity)
                }
                ScrollView(.vertical) {
                    /// YOUR SCROLL CONTENT
                    ScrollContent()
                        .safeAreaInset(edge: .top, spacing: 0) {
                            Rectangle()
                                .fill(.clear)
                                .frame(height: detailHeight)
                                .offsetY { offset in
                                    /// We don't want the header view to go all the way to the top because the scroll content may be bigger at times, so limiting it to merely stay at the top of the screen.
                                    coordinator.headerOffset = max(min(-offset, detailHeight), 0)
                                }
                        }
                }
                .scrollDisabled(!hideLayer)
                .contentMargins(.top, detailHeight, for: .scrollIndicators)
                .background {
                    Rectangle()
                        .fill(.background)
                        .padding(.top, scrollContentHeight)
                }
                .animation(.easeInOut(duration: 0.3).speed(1.5)) {
                    $0.offset(y: animateView ? 0 : scrollContentHeight)
                        .opacity(animateView ? 1.0 : 0)
                }
                /// Hero Kinda View
                ImageView(post: post)
                    .allowsHitTesting(false)
                    .frame(
                        width: animateView ? size.width : rect.width,
                        height: animateView ? rect.height * scale : rect.height
                    )
                    .clipShape(.rect(cornerRadius: animateView ? 0 : 10))
                    .overlay(alignment: .top) {
                        HeaderActions(post)
                            .offset(y: coordinator.headerOffset)
                            .padding(.top, safeArea.top)
                    }
                    .offset(x: animateView ? 0 : rect.minX, y: animateView ? 0 : rect.minY)
                    .offset(y: animateView ? -coordinator.headerOffset: 0)
            }
        }
        .ignoresSafeArea()
    }
    
    /// Scroll Content
    @ViewBuilder
    func ScrollContent() -> some View {
        DummyContent()
    }
    
    @ViewBuilder
    func HeaderActions(_ post: Item) -> some View {
        HStack {
            Spacer(minLength: 0)
            
            Button(action: {
                coordinator.toogleView(show: false, frame: .zero, post: post)
                
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.primary, .bar)
                    .padding(10)
                    .contentShape(.rect)
            })
        }
        .animation(.easeInOut(duration: 0.3)) {
            $0
                .opacity(coordinator.hideLayer ? 1 : 0)
        }
    }
}

#Preview {
    ContentView()
}
