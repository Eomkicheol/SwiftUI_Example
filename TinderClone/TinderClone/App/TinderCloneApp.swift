//
//  TinderCloneApp.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import SwiftUI

@main
struct TinderCloneApp: App {
    @StateObject var matchManager = MatchManager(service: MockMatchService())
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(matchManager)
        }
    }
}
