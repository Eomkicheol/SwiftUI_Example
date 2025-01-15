//
//  ContentView.swift
//  AutoScrollingTabs
//
//  Created by 엄기철 on 1/15/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      NavigationStack {
        Home()
      }
      .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
