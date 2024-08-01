//
//  Defaults.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 01/08/2024.
//

import Foundation
import Defaults

extension Defaults.Keys {
    /// Whether the app should start tracking when the app is opened
    static let startOnOpen = Key<Bool>("start-on-open", default: false)
    
    /// If the app should show the acceleration gauge
    static let showAcceleration = Key<Bool>("show-acceleration", default: true)
}
