//
//  SnelheidsmeterApp.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import SwiftUI
import SwiftData

@main
struct SnelheidsmeterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    TrackingSession.self
                ])
        }
    }
}
