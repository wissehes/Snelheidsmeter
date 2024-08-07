//
//  SpeedViewModel.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import AsyncLocationKit
import CoreMotion
import SwiftData

@Observable
class SpeedViewModel {
    
    private let manager = AsyncLocationManager(desiredAccuracy: .bestForNavigationAccuracy)
    private var container: ModelContainer? {
        do {
            return try ModelContainer(for: TrackingSession.self)
        } catch {
            print(error)
            return nil
        }
    }
    
    var locations: [CLLocation] = []
    var sessionItems: [TrackingSessionItem] = []
    var location: CLLocation? {
        locations.last
    }
    
    /// Whether the app is currently monitoring the location
    var isMonitoring: Bool = false
    
    var speed: Double {
        guard let speed = location?.speed else { return 0 }

        // Return 0 if the speed is less than 0
        return speed < 0 ? 0 : speed
    }
    
    /**
     Stored monitoring task
     */
    var locationMonitoringTask: Task<Void, Never>?
    
    /**
     Helper function to set the monitoring status with an animation
     */
    private func setMonitoring(_ value: Bool) {
        withAnimation { self.isMonitoring = value }
    }
    
    /// Acceleration in meters per second squared
    /// (Delta V / Delta T) ^2
    /// Where V = speed and T = time
    var acceleration: Double? {
        print("Calculating accelaration...")
        
        // Get the last two items
        let items = locations.suffix(2)
        
        // Make sure all required values are present
        guard let location1 = items.first, let location2 = items.last else { return nil }
        guard location1.speed >= 0, location2.speed >= 0 else { return nil }
        
        // Time difference in seconds
        let timeDifference = location2.timestamp.timeIntervalSince(location1.timestamp)
        print("Difference in time: ", timeDifference)
        
        // Difference in speed (m/s)
        let speedDifference = location2.speed - location1.speed
        print("Difference in speed: ", speedDifference)
        
        // Square root and make the speed difference absolute
        // because you can't square root negative numbers
        let result = sqrt(abs(speedDifference) / timeDifference)
    
        // If the speedDifference was negative, return the result but negative.
        // Otherwise return as normal
        let actualResult = speedDifference < 0 ? -result : result
        print("Result: ", actualResult)
        
        // Check whether the result is NaN, otherwise return
        // the result as normal
        return actualResult.isNaN ? 0 : actualResult
    }
    
    @MainActor
    func startMonitoring() async {
        defer {
            self.setMonitoring(false);
            self.locations = []
            self.sessionItems = []
            // Enable automatic sleep again
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
        print("Starting...")
        
        let permission = await manager.requestPermission(with: .whenInUsage)
        
        guard permission == .authorizedWhenInUse || permission == .authorizedAlways else { return print("Denied location") }
        
        self.setMonitoring(true)
        
        // Disable automatic sleep
        UIApplication.shared.isIdleTimerDisabled = true
        
        for await locationUpdate in await manager.startUpdatingLocation() {
            
            switch locationUpdate {
            case .didUpdateLocations(let locations):
                withAnimation { self.locations.append(contentsOf: locations) }
                if let location = locations.last {
                    self.sessionItems.append(.init(
                        speed: location.speed,
                        acceleration: acceleration, 
                        timestamp: .now,
                        location: location.coordinate
                    ))
                }
            case .didPaused:
                setMonitoring(false)
            case .didResume:
                setMonitoring(true)
            case .didFailWith(error: let error):
                print(error)
            }
        }
        
    }
}
