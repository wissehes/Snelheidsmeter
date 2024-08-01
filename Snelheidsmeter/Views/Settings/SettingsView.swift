//
//  SettingsView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 01/08/2024.
//

import SwiftUI
import Defaults

struct SettingsView: View {
    
    var body: some View {
        List {
            // Auto start
            Section {
                Defaults.Toggle("Start automatically", key: .startOnOpen)
            } header: {
                Text("Auto-start")
            } footer: {
                Text("This toggles whether the app should start tracking when you open the app")
            }
            
            // Acceleration
            Section("Acceleration") {
                Defaults.Toggle("Show acceleration", key: .showAcceleration)
            }
        }.navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
