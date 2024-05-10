//
//  CardStackView.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import SwiftUI

struct CardStackView: View {
    @State private var showMatchView = false
    @StateObject var viewModel = CardsViewModel(service: CardService())
    @EnvironmentObject var matchManager: MatchManager
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    ZStack {
                        ForEach(viewModel.cardModels) { card in
                            CardView(viewModel: viewModel, model: card)
                        }
                    }
                    if !viewModel.cardModels.isEmpty {
                        SwipeActionButtonView(viewModel: viewModel)
                    }
                }
                .blur(radius: showMatchView ? 20 : 0)
                
                if showMatchView {
                    UserMatchView(show: $showMatchView)
                }
            }
            .animation(.easeOut, value: showMatchView)
            .onReceive(matchManager.$matchedUser, perform: { user in
                showMatchView = user != nil
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.tinderLogo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 88)
                }
            }
        }
    }
}

#Preview {
    CardStackView()
        .environmentObject(MatchManager(service: MockMatchService()))
}
