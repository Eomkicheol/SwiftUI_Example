//
//  ContentView.swift
//  InteractiveFloatingButton
//
//  Created by 엄기철 on 4/22/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .brown, .purple, .indigo, .mint, .pink]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(colors, id:\.self) { color in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(color.gradient)
                            .frame(height: 200)
                    }
                }
                .padding(15)
            }
            
            .navigationTitle("Floating Button")
            .overlay(alignment: .bottomTrailing) {
                FloatingButton {
                    FloatingAction(symbol: "tray.full.fill") {
                        print("Tray")
                    }
                    
                    FloatingAction(symbol: "lasso.badge.sparkles") {
                        print("sparkles")
                    }
//                    
                    FloatingAction(symbol: "square.and.arrow.up.fill") {
                        print("Share")
                    }
                    
                    
                } label: { isExpanded in
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                        .scaleEffect(1.02)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black, in: .circle)
                    // Scaling Effect When Expanded
                        .scaleEffect(isExpanded ? 0.9 : 1)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
