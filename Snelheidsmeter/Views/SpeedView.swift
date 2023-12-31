//
//  SpeedView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import SwiftUI

struct SpeedView: View {
    
    var speed: Double
    
    @State private var showMetersPerSecond = false
    
    let gradient = Gradient(colors: [.green, .orange, .pink])
    let minSpeed: Double = 0
    var maxSpeed: Double {
        showMetersPerSecond ? 20 : 200
    }
        
    var formatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.minimumFractionDigits = 2
        formatter.unitOptions = showMetersPerSecond ? .providedUnit : .naturalScale
        return formatter
    }
    
    var formattedSpeed: String {
        let measurement = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)
        return formatter.string(from: measurement)
    }
    
    var body: some View {
        VStack(spacing: 12.5) {
            VStack {
                Label("Snelheid", systemImage: "speedometer")
                    .font(.headline)
                Text(formattedSpeed)
                    .font(.system(.largeTitle, design: .rounded))
            }.onTapGesture {
                showMetersPerSecond.toggle()
            }
            
            Gauge(value: speed, in: minSpeed...maxSpeed) {
                Text("km/h")
            } currentValueLabel: {
                Text(formattedSpeed)
            } minimumValueLabel:  {
                Text(Int(minSpeed).description)
            } maximumValueLabel: {
                Text(Int(maxSpeed).description)
            }.labelsHidden()
                .gaugeStyle(.accessoryLinear)
                .tint(gradient)
        }.padding()
            .frame(height: 150)
    }
}

#Preview {
    SpeedView(speed: 135.50)
}
