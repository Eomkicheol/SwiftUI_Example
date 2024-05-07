//
//  ContentView.swift
//  SwiftUI Animations
//
//  Created by 엄기철 on 4/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var change = false
    
    var body: some View {
        VStack(spacing: 20) {
            TitleText(title: "Animatable Properties")
            SubtitleText(subtitle: "Color")
            BannerText(text: "You can animate the change from one color to anothe")
            
            Text("With Animation")
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(change ? .orange : .blue)
                .padding()
                .withAnimation(Animation.snappy) {
                    self.change.toggle()
                }

        }.font(.title)
    }
}

#Preview {
    ContentView()
}
