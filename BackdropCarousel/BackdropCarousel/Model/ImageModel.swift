//
//  ImageModel.swift
//  BackdropCarousel
//
//  Created by 엄기철 on 1/15/25.
//

import SwiftUI

struct ImageModel: Identifiable {
  var id: String = UUID().uuidString
  var altText: String
  var image: String
}

let images: [ImageModel] = [
  .init(altText: "Mo Eid", image: "pic1"),
  .init(altText: "Codioful", image: "pic2"),
  .init(altText: "Cottonbro", image: "pic3"),
  .init(altText: "Anni", image: "pic4"),
]
