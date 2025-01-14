//
//  ContentView.swift
//  DocumentScanner
//
//  Created by 엄기철 on 1/14/25.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("showIntroView") private var showIntroView: Bool = true
    var body: some View {
      Home()
        .sheet(isPresented: $showIntroView) {
          IntroScreen()
            .interactiveDismissDisabled()
          //For data persistence, I'm goingto use SwiftData and let's createdata models for the app.
        }
    }
}

#Preview {
    ContentView()
}
