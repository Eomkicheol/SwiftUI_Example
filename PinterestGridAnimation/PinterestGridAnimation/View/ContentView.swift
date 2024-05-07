//
//  ContentView.swift
//  PinterestGridAnimation
//
//  Created by 엄기철 on 5/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
            /// NOTE: If you're using NavigationStack, you must hide the default navigation bar.
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
