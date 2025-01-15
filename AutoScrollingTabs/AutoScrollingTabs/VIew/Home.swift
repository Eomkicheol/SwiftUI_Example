//
//  Home.swift
//  AutoScrollingTabs
//
//  Created by 엄기철 on 1/15/25.
//

import SwiftUI

struct Home: View {
  @State private var activeTab: ProductType = .iphone
  @Namespace private var animation
  @State private var productsBasedOnType: [[Product]] = []
  @State private var animationProgress: CGFloat = 0
  @State private var scrollableTabOffset: CGFloat = 0
  @State private var initialOffset: CGFloat = 0
    var body: some View {
      // For Auto Scrolling Content's
      ScrollViewReader { proxy in
        ScrollView(.vertical) {
          // Lazy Stack For Pinning View at Top While Scrolling
//          LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
//            Section {
//              ForEach(productsBasedOnType, id:\.self) { products in
//                ProductSectionView(products)
//              }
//            } header: {
//              ScrollableTabs(proxy)
//            }
//          }
          VStack(spacing: 15) {
            ForEach(productsBasedOnType, id:\.self) { products in
              ProductSectionView(products)
            }
          }
          .offset("CONTENTVIEW") { rect in
            scrollableTabOffset = rect.minY - initialOffset
          }
        }
        .offset("CONTENTVIEW") { rect in
          initialOffset = rect.minY

        }
        .safeAreaInset(edge: .top) {
          ScrollableTabs(proxy)
            .offset(y: scrollableTabOffset  > 0 ? scrollableTabOffset : 0)
        }
      }
      // For Scroll Content Offset Detection
      .coordinateSpace(name: "CONTENTVIEW")
      .navigationTitle("Apple Store")
      //Custom NavBar Background
      .toolbarBackgroundVisibility(.visible, for: .navigationBar)
      .toolbarBackground(.purple, for: .navigationBar)
      .toolbarColorScheme(.dark, for: .navigationBar)
      .background {
        Rectangle()
          .fill(Color("BG"))
          .ignoresSafeArea()
      }
      .onAppear {
        // Filtering Products Based on Product Type (Only Once)
        guard productsBasedOnType.isEmpty else  { return }
        for type in ProductType.allCases {
          let products = products.filter { $0.type == type }
          productsBasedOnType.append(products)
        }
      }
    }

  // Products Sectioned View
  @ViewBuilder
  private func ProductSectionView(_ products: [Product]) -> some View {
    VStack(alignment: .leading, spacing: 15) {
      // Safe Check
      if let firstProduct = products.first {
        Text(firstProduct.type.rawValue)
          .font(.title)
          .fontWeight(.semibold)
      }

      ForEach(products) { product in
        ProductRowView(product)
      }
    }
    .padding(15)
    // - For Auto Scrolling VIA ScrollViewProxy
    .id(products.type)
    .offset("CONTENTVIEW") { rect in
      let minY = rect.minY
      // When the Content Reaches it's top then updating the current active Tap
      if (minY < 30 && -minY < (rect.midY / 2) && activeTab != products.type) && animationProgress == 0  {
        withAnimation(.easeInOut(duration: 0.3)) {
          // Saftey Check
          activeTab = (
            minY < 30 && -minY < (rect.midY / 2) && activeTab != products.type
          ) ? products.type : activeTab
        }
      }
    }
  }

  @ViewBuilder
  private func ProductRowView(_ product: Product) -> some View {
    HStack(spacing: 15) {
      Image(product.productImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
        .padding(10)
        .background {
          RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(.white)
        }

      VStack(alignment: .leading, spacing: 8) {
        Text(product.title)
          .font(.title3)

        Text(product.subtitle)
          .font(.callout)
          .foregroundStyle(.gray)

        Text(product.price)
          .font(.title3)
          .fontWeight(.semibold)
          .foregroundStyle(.purple)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private func ScrollableTabs(_ proxy: ScrollViewProxy) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 10) {
        ForEach(ProductType.allCases, id: \.rawValue) { type in
          Text(type.rawValue)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
          // Active Tab Indicator
            .background(alignment: .bottom, content: {
              if activeTab == type {
                Capsule()
                  .fill(.white)
                  .frame(height: 5)
                  .padding(.horizontal, -5)
                  .offset(y: 15)
                  .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
              }
            })
            .padding(.horizontal, 15)
            .containerShape(Rectangle())
          // Scrolling Tab's When ever the Active tab is Updated
            .id(type.tabID)
            .onTapGesture {
              withAnimation(.easeInOut(duration: 0.3)) {
                activeTab = type
                animationProgress = 1.0
                // Scrolling To the selected Content
                proxy.scrollTo(type, anchor: .topLeading)
              }
            }
        }
      }
      .padding(.vertical, 15)
      .onChange(of: activeTab) { oldValue, newValue in
        withAnimation(.easeInOut(duration: 0.3)) {
          proxy.scrollTo(newValue.tabID, anchor: .center)
        }
      }
      .checkAnimationEnd(for: animationProgress) {
        // Reseting to Default, when the animation was finished
        animationProgress = 0.0
      }
    }
    .background {
      Rectangle()
        .fill(.purple)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
    }
  }
}

#Preview {
  ContentView()
}
