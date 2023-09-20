//
//  ContentView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    var vm = SpeedViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            SpeedView(speed: vm.speed)
            
            Button(vm.isMonitoring ? "Stop volgen" : "Start volgen", systemImage: "location.fill.viewfinder") {
                if vm.isMonitoring {
                    vm.locationMonitoringTask?.cancel()
                } else {
                    vm.locationMonitoringTask = Task { await vm.startMonitoring() }
                }
            }.buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
