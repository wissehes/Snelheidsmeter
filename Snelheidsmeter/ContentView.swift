//
//  ContentView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    
    var vm = SpeedViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 10) {
                
                if vm.isMonitoring {
                    animatingIcon
                        .frame(width: 50)
                } else {
                    stillIcon
                        .frame(width: 50)
                }
                
                SpeedView(speed: vm.speed)
                
                AccelerationView(acceleration: vm.acceleration)
                
                controlButton
                
                NavigationLink {
                    SessionsView()
                } label: {
                    Label("Sessies", systemImage: "square.3.layers.3d")
                }.buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("Snelheid")
        }
    }
    
    var animatingIcon: some View {
        Image(systemName: "dot.radiowaves.left.and.right", variableValue: 0.1)
            .resizable()
            .symbolRenderingMode(.multicolor)
            .symbolEffect(.variableColor.iterative)
            .scaledToFit()
    }
    
    var stillIcon: some View {
        Image(systemName: "dot.radiowaves.left.and.right", variableValue: 0.1)
            .resizable()
            .scaledToFit()
    }
    
    var buttonTitle: String {
        vm.isMonitoring ? String(localized: "Stop volgen") : String(localized: "Start volgen")
    }
    
    var buttonIcon: String {
        vm.isMonitoring ? "location.slash" : "location.fill.viewfinder"
    }
    
    var controlButton: some View {
        Button(buttonTitle, systemImage: buttonIcon) {
            if vm.isMonitoring {
                saveSession()
                vm.locationMonitoringTask?.cancel()
            } else {
                vm.locationMonitoringTask = Task { await vm.startMonitoring() }
            }
        }.buttonStyle(.borderedProminent)
            .contentTransition(.symbolEffect(.replace))
            .tint(vm.isMonitoring ? .red : .accentColor)
    }
    
    /// Saves the session to SwiftData
    func saveSession() {
        guard let firstLocation = vm.locations.first, !vm.sessionItems.isEmpty else { return print("No location items...") }
        
        let session = TrackingSession(
            startDate: firstLocation.timestamp,
            endDate: .now,
            items: vm.sessionItems
        )
        
        context.insert(session)
    }
}

#Preview {
    ContentView()
}
