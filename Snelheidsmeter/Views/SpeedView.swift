//
//  SpeedView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import SwiftUI
import Defaults

struct SpeedView: View {
    
    /// Speed in meters per second
    var speed: Double
    
    @Default(.speedDisplay) var speedDisplayType
    var showMetersPerSecond: Bool {
        speedDisplayType == .metersPerSecond
    }
    
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
    
    var speedValue: Double {
        let measurement = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)

        if showMetersPerSecond {
            return speed
        } else {
            return measurement.converted(to: .kilometersPerHour).value
        }
    }
    
    var body: some View {
        VStack(spacing: 12.5) {
            VStack {
                Label("Snelheid", systemImage: "speedometer")
                    .font(.headline)
                Text(formattedSpeed)
                    .font(.system(.largeTitle, design: .rounded))
            }.onTapGesture {
                if showMetersPerSecond {
                    speedDisplayType = .kilometersPerHour
                } else {
                    speedDisplayType = .metersPerSecond
                }
            }
            
            Gauge(value: speedValue, in: minSpeed...maxSpeed) {
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
    SpeedView(speed: 100.23441 / 3.6)
}
