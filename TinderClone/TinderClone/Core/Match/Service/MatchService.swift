//
//  MatchService.swift
//  TinderClone
//
//  Created by 엄기철 on 5/10/24.
//

import Foundation

protocol MatchServiceProtocol {
    func fetchMatches() async throws -> [Match]
}
