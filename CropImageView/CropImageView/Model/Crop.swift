//
//  Crop.swift
//  CropImageView
//
//  Created by 엄기철 on 5/26/24.
//

import SwiftUI

// MARK: Crop Config
enum Crop: Equatable {
    /// The crop image view's shape type and size are defined.
    case circle
    case rectangle
    case square
    case custom(CGSize)
    
    /// used to display the button on the action sheet.
    func name() -> String {
        switch self {
        case .circle:
            return "Circle"
        case .rectangle:
            return "Rectangle"
        case .square:
            return "Square"
        case let .custom(size):
            return "Custom \(Int(size.width))x\(Int(size.height))"
        }
    }
    /// You can also define custom sizes for circle, rectangle, and square by doing the same thing as custom size. These sizes represent the crop view size.
    func size() -> CGSize {
        switch self {
        
        case .circle:
            return .init(width: 300, height: 300)
        case .rectangle:
            return .init(width: 300, height: 500)
        case .square:
            return .init(width: 300, height: 300)
        case let .custom(size):
            return size
        }
    }
}
