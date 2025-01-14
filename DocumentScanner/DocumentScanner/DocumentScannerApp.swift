//
//  DocumentScannerApp.swift
//  DocumentScanner
//
//  Created by 엄기철 on 1/14/25.
//

import SwiftUI

@main
struct DocumentScannerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .modelContainer(for: Document.self)
        }
    }
}
