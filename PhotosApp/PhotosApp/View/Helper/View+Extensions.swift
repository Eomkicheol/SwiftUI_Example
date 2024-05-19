//
//  View+Extensions.swift
//  PhotosApp
//
//  Created by 엄기철 on 5/19/24.
//

import SwiftUI

/// This modifier will extract the item's position in the scrollview as well as the scrollview boundaries values,
/// which we can then use to determine whether the item is visible or not.
extension View {
    @ViewBuilder
    func didFrameChange(result: @escaping (CGRect, CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let frame = $0.frame(in: .scrollView(axis: .vertical))
                    let bounds = $0.bounds(of: .scrollView(axis: .vertical)) ?? .zero
                    
                    Color.clear
                        .preference(key: FrameKey.self, value: .init(frame: frame, bounds: bounds))
                        .onPreferenceChange(FrameKey.self, perform: { value in
                            result(value.frame, value.bounds)
                        })
                }
        }
    }
}

struct ViewFrame: Equatable {
    var frame: CGRect = .zero
    var bounds: CGRect = .zero
}

struct FrameKey: PreferenceKey {
    static var defaultValue: ViewFrame = .init()
    static func reduce(value: inout ViewFrame, nextValue: () -> ViewFrame) {
        value = nextValue()
    }
}
