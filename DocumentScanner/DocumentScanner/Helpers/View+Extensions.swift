//
//  View+Extensions.swift
//  DocumentScanner
//
//  Created by 엄기철 on 1/14/25.
//

import SwiftUI


extension View {
  @ViewBuilder
  func hSpacing(_ alignment: Alignment) -> some View {
    self
      .frame(maxWidth: .infinity, alignment: alignment)
  }

  func vSpacing(_ alignment: Alignment) -> some View {
    self
      .frame(maxHeight: .infinity, alignment: alignment)
  }

  //Easy-to-use overlayed Loading Screen
  @ViewBuilder
  func loadingScreen(status: Binding<Bool>) -> some View {
    self
      .overlay {
        ZStack {
          Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()

          ProgressView()
            .frame(width: 40, height: 40)
            .background(.bar, in: .rect(cornerRadius: 10))
        }
        .opacity(status.wrappedValue ? 1 : 0)
        .allowsHitTesting(status.wrappedValue)
      }
  }

  ///Let's begin by designing the introductoryscreen for our app.
  /// The primary inspirationfor this design stems from Apple's defaultapps, particularly their feature lists.
  /// Myintention is to replicate the intro screen in asimilar manner and leverage AppStorage todisplay the feature list only once when theapp is first launched.

  var snappy: Animation {
    .snappy(duration: 0.25, extraBounce: 0)
  }
}
