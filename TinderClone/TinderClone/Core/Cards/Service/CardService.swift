//
//  CardService.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import Foundation


struct CardService {
    func fetchCardModels() async throws -> [CardModel] {
        let users = MockData.users
        return users.map { CardModel(user: $0) }
    }
}
