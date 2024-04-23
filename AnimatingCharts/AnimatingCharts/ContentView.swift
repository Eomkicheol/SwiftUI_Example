//
//  ContentView.swift
//  AnimatingCharts
//
//  Created by 엄기철 on 4/23/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    //View Properties
    @State private var appdownloads: [Download] = sampleDownloads
    @State private var isAnimated: Bool = false
    @State private var trigger: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    ForEach(appdownloads) { download in
                        ///Step 2: Use the property we created earlier as a ternary operator to display the chart y-axis value (for Sector Mark, use it on the angle plottable value).
                        BarMark(
                            x: .value("Month",download.month),
                            y: .value("Downloads",download.isAnimated ? download.value : 0)
                        )
                        .foregroundStyle(.red.gradient)
                        .opacity(download.isAnimated ? 1 : 0)
                    }
                }
                /// Step 3: For LineMark, BarMark, and AreaMark, it's a must we declare the y-axis domain range, Otherwise, the animation won't work properly. (For my usage, I used a rough value of 12,000, but you can use the array max) property to fetch the maximum value in the chart)
                .chartYScale(domain: 0...12000)
                .frame(height: 250)
                .padding()
                .background(.background, in: .rect(cornerRadius: 10))
                
                Spacer(minLength: 0)
            }
            .padding()
            .background(.gray.opacity(0.12))
            .navigationTitle("Animated Chart's")
            .onAppear(perform: animateChart)
            .onChange(of: trigger, initial: false) { oldValue, newValue in
                resetChartAnimation()
                animateChart()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        /// Adding Extra Dummy Data
                        appdownloads.append(contentsOf: [
                            .init(date: .createDate(1, 2, 24), value: 4700),
                            .init(date: .createDate(1, 3, 24), value: 9700),
                            .init(date: .createDate(1, 4, 24), value: 1700),
                        ])
                        trigger.toggle()
                    }, label: {
                        Text("trigger")
                    })
                }
            }
        }
    }
    
    private func animateChart() {
        /// Finally, animate each item with a delay to create the chart animation.
        guard !isAnimated else { return }
        isAnimated = true
        
        ///Just like how we can update data when we pass a binding value to ForEach, we can apply the same method to change or update the data without subscripting an array with indices.
        $appdownloads.enumerated().forEach { index, value in
            /// Optionally, you can limit animation after a certain index. Consider that if we have a large set of data and do not want to animate all of the elements, we can limit the animation to a specific number of indices, such as 20.
            if index > 5 {
                value.wrappedValue.isAnimated =  true
            } else {
                let delay = Double(index) * 0.05
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.smooth) {
                        value.wrappedValue.isAnimated = true
                    }
                }
            }
            
        }
    }
    
    private func resetChartAnimation() {
        $appdownloads.forEach { download in
            download.wrappedValue.isAnimated = false
        }
        isAnimated = false
    }
}

#Preview {
    ContentView()
}
