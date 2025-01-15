//
//  Extensions.swift
//  AutoScrollingTabs
//
//  Created by 엄기철 on 1/15/25.
//

import SwiftUI

//Since our product array contains onlyone type, this extension will be useful toretrieve the product type. If you havemixed products, don't use thisextension.

extension [Product] {

  // Return the Array's First Product Type
  var type: ProductType {
    if let firstProduct = self.first {
      return firstProduct.type
    }

    return .iphone
  }
}


struct OffsetKey: PreferenceKey {
  static var defaultValue: CGRect = .zero

  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

extension View {
  @ViewBuilder
  func offset(
    _ coordinateSpace: AnyHashable,
    completion: @escaping (CGRect) -> ()
  ) -> some View {
    self
      .overlay {
        GeometryReader { proxy in
          let rect = proxy.frame(in: .named(coordinateSpace))

          Color.clear
            .preference(key: OffsetKey.self, value: rect)
            .onPreferenceChange(OffsetKey.self, perform: completion)
        }
      }
  }
}

extension View {
  @ViewBuilder
  func checkAnimationEnd<Value: VectorArithmetic>(
    for value: Value,
    completion: @escaping () -> ()
  ) -> some View {
    self.modifier(AnimationEndCallback(for: value, onEnd: completion))
  }
}

//Animation OnEnd CallBack
fileprivate struct AnimationEndCallback<Value: VectorArithmetic>: Animatable, ViewModifier {
  var animatableData: Value {
    didSet {
      checkIfFinished()
    }
  }

  var endValue: Value
  var onEnd: () -> ()

  init(for value: Value, onEnd: @escaping () -> Void) {
    self.animatableData = value
    self.endValue = value
    self.onEnd = onEnd
  }

  func body(content: Content) -> some View {
    content
  }

  private func checkIfFinished() {
    if endValue == animatableData {
      DispatchQueue.main.async {
        onEnd()
      }
    }
  }

}
