//
//  MJSApp.swift
//  MJS
//
//  Created by Robert Goedman on 3/24/24.
//

import SwiftUI
import SwiftData

@main
struct MJSApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Tournament.self, 
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
