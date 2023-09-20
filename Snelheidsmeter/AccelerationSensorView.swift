//
//  AccelerationSensorView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 20/09/2023.
//

import SwiftUI
import CoreMotion

struct AccelerationSensorView: View {
    
    let manager = CMMotionManager()
    
    @State private var acceleration: CMAcceleration?
    
    var body: some View {
        VStack {
            Text("Acceleration:")
            Text("X: \(acceleration?.x.formatted() ?? "?")")
            Text("Y: \(acceleration?.y.formatted() ?? "?")")
            Text("Z: \(acceleration?.z.formatted() ?? "?")")
        }
            .onAppear {
//                manager.deviceMotion?.user
                manager.deviceMotionUpdateInterval = 1
                manager.startDeviceMotionUpdates(to: .current!) { motion, error in
                    print(error, motion)
                    self.acceleration = motion?.userAcceleration
                }
            }
    }
}

#Preview {
    AccelerationSensorView()
}
