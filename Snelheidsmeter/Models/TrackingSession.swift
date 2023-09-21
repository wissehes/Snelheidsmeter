//
//  TrackingSession.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 21/09/2023.
//

import Foundation
import SwiftData
import CoreLocation

@Model class TrackingSession {
    var startDate: Date
    var endDate: Date?
    
    var items: [TrackingSessionItem]
    
    init(startDate: Date, endDate: Date? = nil, items: [TrackingSessionItem]) {
        self.startDate = startDate
        self.endDate = endDate
        self.items = items
    }
}

struct TrackingSessionItem: Codable {
    let speed: Double
    let acceleration: Double?
    let timestamp: Date
}
