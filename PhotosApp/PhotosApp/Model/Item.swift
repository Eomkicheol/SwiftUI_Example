//
//  Item.swift
//  PhotosApp
//
//  Created by 엄기철 on 5/10/24.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var image: UIImage?
    var previewImage: UIImage?
    var appeared: Bool = false
}

var sampleItems: [Item] = [
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 1")
    ),
    .init(
        title: "Han-Chieh Lee",
        image: UIImage(named: "Pic 2")
    ),
    .init(
        title: "新宇 王",
        image: UIImage(named: "Pic 3")
    ),
    .init(
        title: "Abril Altamirano",
        image: UIImage(named: "Pic 4")
    ),
    .init(
        title: "Gülsah Aydogan",
        image: UIImage(named: "Pic 5")
    ),
    .init(
        title: "Melike Sayar Melikesayar",
        image: UIImage(named: "Pic 6")
    ),
    .init(
        title: "Pelageia Zelenina",
        image: UIImage(named: "Pic 7")
    ),
    .init(
        title: "Ofir Eliav",
        image: UIImage(named: "Pic 8")
    ),
    .init(
        title: "Melike Sayar Melikesayar",
        image: UIImage(named: "Pic 9")
    ),
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 10")
    ),
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 11")
    ),
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 12")
    ),
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 13")
    ),
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 14")
    ),
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 15")
    ),
    .init(
        title: "Fanny Hagan",
        image: UIImage(named: "Pic 16")
    ),
]
