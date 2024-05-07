//
//  BannerText.swift
//  SwiftUI Animations
//
//  Created by 엄기철 on 4/29/24.
//

import SwiftUI

struct BannerText: View {
    var text: String
    var backColor: Color
    var textColor: Color
    
    init(text: String, backColor: Color = Color.orange, textColor: Color = Color.primary) {
        self.text = text
        self.backColor = backColor
        self.textColor = textColor
    }
    
    var body: some View {
        Text(text)
            .font(.title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backColor)
            .foregroundStyle(textColor)
    }
}

#Preview {
    ContentView()
}
