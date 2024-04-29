//
//  ContentView.swift
//  ExpandableSearchBar
//
//  Created by 엄기철 on 4/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
