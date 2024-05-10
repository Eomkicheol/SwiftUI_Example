//
//  Match.swift
//  TinderClone
//
//  Created by 엄기철 on 5/9/24.
//

import Foundation

struct Match: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let timestamp: Date
    
    var user: User?
}
