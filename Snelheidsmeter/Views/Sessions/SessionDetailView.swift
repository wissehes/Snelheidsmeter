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
    
    var duration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        
        return formatter.string(from: session.startDate, to: session.endDate ?? .now) ?? "--:--"
    }
    
    var body: some View {
        List {
            Section {
                Text("Duration: \(duration)")
            }
            
            Section("Map") {
                Map {
                    MapPolyline(coordinates: points)
                        .stroke(.blue, lineWidth: 5)
                }.frame(height: 400)
                .listRowInsets(EdgeInsets())
            }
        }.navigationTitle("Session details")
    }
}

//#Preview {
//    SessionDetailView()
//}
