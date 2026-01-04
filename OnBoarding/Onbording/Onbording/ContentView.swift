//
//  ContentView.swift
//  Onbording
//
//  Created by 엄기철 on 1/4/26.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id  = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

struct ContentView: View {
    
    @AppStorage("didFinishOnboarding") private var didFinishOnboarding: Bool = false
    @State private var index: Int = 0
    
    let pages: [OnboardingPage] = [
        .init(
            title: "Build faster",
            subtitle: "Ship clean SwiftUI screens without the chaos",
            systemImage: "bolt.fill"
        ),
        .init(
            title: "Stay consistent",
            subtitle: "Design rules that scale across your app",
            systemImage: "square.grid.2x2.fill"
        ),
        .init(
            title: "Launch polished",
            subtitle: "Micro-interactions that make it feel premium.",
            systemImage: "sparkles"
        )
    ]
    
    var body: some View {
        VStack {
            topBar
            
            TabView(selection: $index) {
                ForEach(pages.indices, id: \.self) { i in
                    pageView(pages[i])
                        .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            bottomBar
        }
    }
}

extension ContentView {
    private var topBar: some View {
        HStack {
            if index > 0 {
                Button("Back") {
                    withAnimation(.spring()) {
                        index -= 1
                    }
                }
            }
            
            Spacer()
            
            if index < pages.count - 1 {
                Button("Skip") {
                    withAnimation(.spring()) {
                        index = pages.count - 1
                    }
                }
            }
        }
        .font(.headline).padding()
    }
    
    @ViewBuilder
    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 18) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 60, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
            
            Text(page.title)
                .font(.system(size: 34, weight: .bold))
            
            Text(page.subtitle)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            
            Spacer()
        }
    }
    
    private var progressPiolls: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { i in
                Capsule()
                    .frame(width: i == index ? 22 : 8, height: 8)
                    .animation(.spring(), value: index)
                    .foregroundStyle(.secondary.opacity(i == index ? 1: 0.35))
            }
        }
        .padding(.top, 4)
    }
    
    private var bottomBar: some View {
        VStack(spacing: 14) {
            progressPiolls
            
            Button {
                withAnimation(.spring()) {
                    if index < pages.count - 1 {
                        index += 1
                    } else {
                        didFinishOnboarding = true 
                    }
                }
            } label: {
                Text(index < pages.count - 1 ? "Continue" : "Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 16))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
