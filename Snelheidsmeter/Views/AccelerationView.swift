//
//  AccelerationView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import SwiftUI

struct AccelerationView: View {
    
    var acceleration: Double?
    
    let gradient = Gradient(colors: [.green, .orange, .pink])
    let minAccel: Double = -10
    let maxAccel: Double = 10
    
    var formatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.minimumFractionDigits = 2
        return formatter
    }
    
    var formattedAcceleration: String {
        let measurement = Measurement(value: acceleration ?? 0, unit: UnitAcceleration.metersPerSecondSquared)
        return formatter.string(from: measurement)
    }
    
    var body: some View {
        VStack(spacing: 12.5) {
            VStack {
                Label("Versnelling", systemImage: "speedometer")
                    .font(.headline)
                Text(formattedAcceleration)
                    .font(.system(.largeTitle, design: .rounded))
            }
            
            Gauge(value: acceleration ?? 0, in: minAccel...maxAccel) {
                Text("Versnelling")
            } currentValueLabel: {
                Text(formattedAcceleration)
            } minimumValueLabel:  {
                Text(Int(minAccel).description)
            } maximumValueLabel: {
                Text(Int(maxAccel).description)
            }.labelsHidden()
                .gaugeStyle(.accessoryLinear)
                .tint(gradient)
        }.padding()
            .frame(height: 150)
    }
}

#Preview {
    AccelerationView(acceleration: 2.4)
}
