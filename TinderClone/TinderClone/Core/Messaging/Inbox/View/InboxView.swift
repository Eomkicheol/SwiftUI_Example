//
//  InboxView.swift
//  TinderClone
//
//  Created by 엄기철 on 5/9/24.
//

import SwiftUI

struct InboxView: View {
    var body: some View {
        NavigationStack {
            List {
                NewMatchesView()
            }
            .listStyle(.plain)
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    InboxView()
}
