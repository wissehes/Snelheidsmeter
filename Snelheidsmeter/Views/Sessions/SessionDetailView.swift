//
//  SessionDetailView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 27/07/2024.
//

import SwiftUI
import MapKit

struct SessionDetailView: View {
    
    var session: TrackingSession
    
    var points: [CLLocationCoordinate2D] {
        session.items.map { $0.location }
    }
    
    var body: some View {
        List {
            Section {
                if let endDate = session.endDate {
                    Text("Duration: \(session.startDate...endDate)")
                } else {
                    Text("Start date: \(session.startDate)")
                }
            }
            
            Section("Map") {
                Map {
                    MapPolyline(coordinates: points)
                        .stroke(.blue, lineWidth: 5)
                }
            }
        }.navigationTitle("Session details")
    }
}

//#Preview {
//    SessionDetailView()
//}
