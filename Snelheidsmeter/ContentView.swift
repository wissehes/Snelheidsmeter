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
            }
            .padding()
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
        vm.isMonitoring ? "Stop volgen" : "Start volgen"
    }
    
    var buttonIcon: String {
        vm.isMonitoring ? "location.slash" : "location.fill.viewfinder"
    }
    
    var controlButton: some View {
        Button(buttonTitle, systemImage: buttonIcon) {
            if vm.isMonitoring {
                vm.locationMonitoringTask?.cancel()
            } else {
                vm.locationMonitoringTask = Task { await vm.startMonitoring() }
            }
        }.buttonStyle(.borderedProminent)
            .contentTransition(.symbolEffect(.replace))
            .tint(vm.isMonitoring ? .red : .accentColor)
    }
}

#Preview {
    ContentView()
}
