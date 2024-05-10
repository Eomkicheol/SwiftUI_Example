//
//  MatchManager.swift
//  TinderClone
//
//  Created by 엄기철 on 5/9/24.
//

import Foundation

@MainActor
class MatchManager: ObservableObject {
    
    @Published var matchedUser: User?
    @Published var matches = [Match]()
    
    private let service: MatchServiceProtocol
    
    init(service: MatchServiceProtocol) {
        self.service = service
    }
    
    func fetchMatches() async {
        do {
            self.matches = try await self.service.fetchMatches()
        } catch  {
            print("DEBUG: Failed to fetch matches with error: \(error)")
        }
    }
    
    func checkForMatch(withUser user: User) {
         
        let didMatch =  Bool.random()
        
        if didMatch {
            matchedUser = user
        }
    }
}
