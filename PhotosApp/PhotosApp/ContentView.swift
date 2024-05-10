//
//  ContentView.swift
//  PhotosApp
//
//  Created by 엄기철 on 5/10/24.
//

import SwiftUI

struct ContentView: View {
    var coordinator: UICoordinator = .init()
    var body: some View {
        NavigationStack {
            Home()
                .environment(coordinator)
            /// So, when a detail view appears, indicating that the selected item is not nil, I will disable home view interactions until the detail view is visible.
                .allowsHitTesting(coordinator.selectedItem == nil )
        }
        .overlay {
            /// Let's hide the Home View when the detail is presented.
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(coordinator.animateView ? 1 : 0)
            
        }
        .overlay {
            if coordinator.selectedItem != nil {
                Detail()
                    .environment(coordinator)
                /// The detail view interactions are disabled until the detail view is visible.
                    .allowsHitTesting(coordinator.showDetailView)
            }
        }
        .overlayPreferenceValue(HeroKey.self) { value in
            if let selectedItem = coordinator.selectedItem,
               let sAnchor = value[selectedItem.id + "SOURCE"],
               let dAnchor = value[selectedItem.id + "DEST"] {
                HeroLayer(
                    item: selectedItem,
                    sAnchor: sAnchor,
                    dAnchor: dAnchor
                )
                .environment(coordinator)
            }
        }
    }
}

#Preview {
    ContentView()
}
