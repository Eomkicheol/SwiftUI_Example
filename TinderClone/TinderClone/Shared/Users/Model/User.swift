//
//  User.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import Foundation


struct User: Codable, Identifiable, Hashable {
    let id: String
    let fullName: String
    let age: Int
    let profileImageURLs: [String]
    let sex: String
}

extension User {
    var firstName: String {
        let components = fullName.components(separatedBy: " ")
        return components[0]
    }
}
