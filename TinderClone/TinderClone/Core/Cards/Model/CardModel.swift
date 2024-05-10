//
//  CardModel.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import Foundation


struct CardModel {
    let user: User
}

extension CardModel: Identifiable, Hashable {
    var id: String { return user.id }
}
