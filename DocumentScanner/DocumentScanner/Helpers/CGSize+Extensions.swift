//
//  CGSize+Extensions.swift
//  DocumentScanner
//
//  Created by 엄기철 on 1/14/25.
//

import SwiftUI

extension CGSize {
  // This function will return a new size that fits the given size in an aspect ration
  func aspectFit(_ to: CGSize) -> CGSize {
    let scaleX = to.width / self.width
    let scalY = to.height / self.height
    let aspectRatio = min(scaleX, scalY)
    return .init(width: aspectRatio * width, height: aspectRatio  * height)
  }
}
