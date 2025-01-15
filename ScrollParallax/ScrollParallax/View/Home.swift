//
//  Home.swift
//  ScrollParallax
//
//  Created by 엄기철 on 1/15/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
      ScrollView(.vertical) {
        LazyVStack(spacing: 15) {
          DummySection(title: "Social Media")
          DummySection(title: "Sales", isLong: true)

          //Parallax Image
          ParallaxImageView(usesFullWidth: true) { size in
            Image("pic1")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: size.width, height: size.height)
          }
          .frame(height: 300)

          DummySection(title: "Busniess", isLong: true)

          DummySection(title: "Promotion", isLong: true)

          ParallaxImageView(maximumMovement: 150, usesFullWidth: false) { size in
            Image("pic2")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: size.width, height: size.height)
          }
          .frame(height: 400)

          DummySection(title: "YouTube")

          DummySection(title: "Twitter (X)")

          DummySection(title: "Marketing Campaign", isLong: true)

          DummySection(title: "Conclusion", isLong: true)
        }
        .padding(15)
      }
      .toolbarTitleDisplayMode(.inline)
    }

  // Dummy Section
  @ViewBuilder
  func DummySection(title: String, isLong: Bool = false) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.title)
        .bold()

      Text(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. \(isLong ? "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged." : "")"
      )
      .multilineTextAlignment(.leading)
      .kerning(1.2)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct ParallaxImageView<Content: View>: View {
  var maximumMovement: CGFloat = 100
  var usesFullWidth: Bool = false
  @ViewBuilder var content: (CGSize) -> Content
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      // Movement Animation Properties
      let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
      let scrollViewHeight = proxy.bounds(of: .scrollView)?.size.height ?? 0
      let maximumMovement = min(maximumMovement, (size.height * 0.35))
      let stretchedSize: CGSize = .init(
        width: size.width,
        height: size.height + maximumMovement
      )

      let progress = minY / scrollViewHeight
      let cappedProgress = max(min(progress, 1.0), -1.0)
      let movementOffset = cappedProgress * -maximumMovement

      content(size)
        .offset(y: movementOffset)
        .frame(width: stretchedSize.width, height: stretchedSize.height)
        .frame(width: size.width, height: size.height)
        .clipped()
    }
    .containerRelativeFrame(usesFullWidth ? [.horizontal] : [])
  }
}

#Preview {
  Home()
}
