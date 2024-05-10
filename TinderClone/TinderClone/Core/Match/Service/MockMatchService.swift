//
//  MockMatchService.swift
//  TinderClone
//
//  Created by 엄기철 on 5/10/24.
//

import Foundation

struct MockMatchService: MatchServiceProtocol {
    func fetchMatches() async throws -> [Match] {
        return MockData.matches
    }
}



