//
//  UserLocationData.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/29/22.
//

import Foundation

struct UserLocationData: Encodable {
    var user: User
    var id = UUID()
    var latitude: Double
    var longitude: Double
    var timestamp: Date
}
