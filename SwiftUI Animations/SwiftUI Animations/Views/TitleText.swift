//
//  TitleText.swift
//  SwiftUI Animations
//
//  Created by 엄기철 on 4/29/24.
//

import SwiftUI

struct TitleText: View {
    var title: String = ""
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
    }
}

#Preview {
    TitleText(title: "Hello, world!")
}
