//
//  View+Extensions.swift
//  PinterestGridAnimation
//
//  Created by 엄기철 on 5/7/24.
//

import SwiftUI

extension View {
    /// SafeArea
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
    @ViewBuilder
    func offsetY(result: @escaping (CGFloat) -> ()) -> some View {
        self.overlay {
            GeometryReader {
                let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        result(value)
                    })
            }
        }
    }
}


/// Preference Keys
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout Value, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

