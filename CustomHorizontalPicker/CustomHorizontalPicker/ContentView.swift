//
//  ContentView.swift
//  CustomHorizontalPicker
//
//  Created by 엄기철 on 4/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var config: WheelPicker.Config = .init(count: 30, steps: 5, spacing: 15, multiplier: 10)
    @State private var value: CGFloat = 10
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    Text(verbatim: "\(value)")
                        .font(.largeTitle.bold())
                        .contentTransition(.numericText(value: value))
                        .animation(.snappy, value: value)
                    
                    Text("lbs")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Button(action: {
                        withAnimation(.snappy(duration: 0.5, extraBounce: 0)) {
                            value = 0
                        }
                    }, label: {
                        Text("Initialise")
                            .font(.subheadline)
                            .foregroundStyle(.gray.opacity(0.7))
                    })
                }
                .padding(.bottom, 30)
                WheelPicker(config: config, value: $value)
                    .frame(height: 60)
            }
            .navigationTitle("Wheel Picker")
            
        }
    }
}

#Preview {
    ContentView()
}
