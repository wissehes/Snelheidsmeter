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

struct TrackingSessionItem: Codable, Identifiable {
    let speed: Double
    let acceleration: Double?
    let timestamp: Date
    let location: CLLocationCoordinate2D
    
    var id: String {
        "\(location.latitude)-\(location.longitude)-\(timestamp.timeIntervalSince1970)"
    }
}

/// Extension to make CLLocationCoordinate2D conform to the Codable protocol
extension CLLocationCoordinate2D: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.init()
        longitude = try container.decode(Double.self)
        latitude = try container.decode(Double.self)
    }
}
