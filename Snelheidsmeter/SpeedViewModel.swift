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

@Observable
class SpeedViewModel {
    
    private let manager = AsyncLocationManager(desiredAccuracy: .bestForNavigationAccuracy)
    
    var location: CLLocation?
    var isMonitoring: Bool = false
    
    var speed: Double {
        guard let speed = location?.speed else { return 0 }
        
        if speed < 0 {
            return 0
        } else {
            return speed
        }
    }
    
    var locationMonitoringTask: Task<Void, Never>?
    
    func setMonitoring(_ value: Bool) {
        withAnimation { self.isMonitoring = value }
    }
    
    @MainActor
    func startMonitoring() async {
        defer {
            self.setMonitoring(false);
            self.location = nil
        }
        
        print("Starting...")
        
        let permission = await manager.requestPermission(with: .whenInUsage)
        
        guard permission == .authorizedWhenInUse || permission == .authorizedAlways else { return print("Denied location") }
        
        self.setMonitoring(true)
        
        for await locationUpdate in await manager.startUpdatingLocation() {
            
            switch locationUpdate {
            case .didUpdateLocations(let locations):
                withAnimation { self.location = locations.last }
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
