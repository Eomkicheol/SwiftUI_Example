//
//  SubTitleText.swift
//  SwiftUI Animations
//
//  Created by 엄기철 on 4/29/24.
//

import SwiftUI

struct SubtitleText: View {
    var subtitle: String = ""
    
    init(subtitle: String) {
        self.subtitle = subtitle
    }
    
    var body: some View {
        Text(subtitle)
            .font(.title)
            .foregroundStyle(.gray)
    }
}

#Preview {
    SubtitleText(subtitle: "SubTitle")
}
