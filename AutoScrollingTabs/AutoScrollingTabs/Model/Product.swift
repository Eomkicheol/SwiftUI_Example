//
//  Product.swift
//  AutoScrollingTabs
//
//  Created by 엄기철 on 1/15/25.
//

import SwiftUI

struct Product: Identifiable, Hashable {
  var id: UUID = UUID()
  var type: ProductType
  var title: String
  var subtitle: String
  var price: String
  var productImage: String = ""
}


enum ProductType: String, CaseIterable {
  case iphone = "iPhone"
  case ipad = "iPad"
  case macbook = "MacBook"
  case appleWatch = "Apple Watch"
  case desktop = "Desktop"
  case airpods = "Airpods"

  var tabID: String {
    // Cteating Another UniqueID for Tab Scrolling
    return self.rawValue + self.rawValue.prefix(4)
  }
}

var products: [Product] = [
  .init(
    type: .appleWatch,
    title: "Apple Watch",
    subtitle: "Ultra: Alphine Loop",
    price: "$999",
    productImage: "appleWatch"
  ),
  .init(
    type: .appleWatch,
    title: "Apple Watch",
    subtitle: "Series 8: Black",
    price: "$599",
    productImage: "appleWatch"
  ),
  .init(
    type: .appleWatch,
    title: "Apple Watch",
    subtitle: "Series 6: Red",
    price: "$359",
    productImage: "appleWatch"
  ),

    .init(
      type: .appleWatch,
      title: "Apple Watch",
      subtitle: "Series 4: Black",
      price: "$250",
      productImage: "appleWatch"
    ),

    .init(
      type: .iphone,
      title: "iPhone 14 Pro Max",
      subtitle: "A16 - Purple",
      price: "$1299",
      productImage: "iPhone"
    ),

    .init(
      type: .iphone,
      title: "iPhone 13",
      subtitle: "A15 - Pink",
      price: "$699",
      productImage: "iPhone"
    ),

    .init(
      type: .iphone,
      title: "iPhone 12",
      subtitle: "A14 - blue",
      price: "$599",
      productImage: "iPhone"
    ),

    .init(
      type: .iphone,
      title: "iPhone 11",
      subtitle: "A13 - Purple",
      price: "$499",
      productImage: "iPhone"
    ),

    .init(
      type: .iphone,
      title: "iPhone SE 2",
      subtitle: "A13 - White",
      price: "$399",
      productImage: "iPhone"
    ),

    .init(
      type: .macbook,
      title: "MacBook Pro 16",
      subtitle: "M2 Max - Silver",
      price: "$2499",
      productImage: "macbook"
    ),

    .init(
      type: .macbook,
      title: "MacBook Pro",
      subtitle: "M1 - Space Gray",
      price: "$1299",
      productImage: "macbook"
    ),

    .init(
      type: .macbook,
      title: "MacBook Air",
      subtitle: "M1 - Gold",
      price: "$999",
      productImage: "macbook"
    ),

    .init(
      type: .ipad,
      title: "iPad Pro",
      subtitle: "M1 - Silver",
      price: "$999",
      productImage: "iPad"
    ),

    .init(
      type: .ipad,
      title: "iPad Air 4",
      subtitle: "A14 - Pink",
      price: "$699",
      productImage: "iPad"
    ),

    .init(
      type: .ipad,
      title: "iPad Mini",
      subtitle: "A15 - Grey",
      price: "$599",
      productImage: "iPad"
    ),

    .init(
      type: .desktop,
      title: "Mac Studio",
      subtitle: "M1 Max - Silver",
      price: "$1999",
      productImage: "iPad"
    ),

    .init(
      type: .desktop,
      title: "Mac Mini",
      subtitle: "M2 Pro - Space Grey",
      price: "$999",
      productImage: "iPad"
    ),

    .init(
      type: .desktop,
      title: "iMac",
      subtitle: "M1 - Purple",
      price: "$1599",
      productImage: "desktop"
    ),

    .init(
      type: .airpods,
      title: "Airpods",
      subtitle: "Pro 2nd Gen",
      price: "$249",
      productImage: "airPods"
    ),

    .init(
      type: .airpods,
      title: "Airpods",
      subtitle: "3rd Gen",
      price: "$179",
      productImage: "airPods"
    ),

    .init(
      type: .airpods,
      title: "Airpods",
      subtitle: "2rd Gen",
      price: "$129",
      productImage: "airPods"
    ),
]

