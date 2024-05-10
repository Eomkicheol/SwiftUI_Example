//
//  MainTabBar.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CardStackView(viewModel: CardsViewModel(service: CardService()))
                .tabItem {
                    Image(systemName: "flame")
                }
                .tag(0)
            
            Text("Search View")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            
            InboxView()
                .tabItem {
                    Image(systemName: "bubble")
                }
                .tag(2)
            
            CurrentUserProfileView(user: MockData.users[2])
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
            
        }
        .tint(.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(MatchManager(service: MockMatchService()))
}
