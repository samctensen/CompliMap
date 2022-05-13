//
//  Profile.swift
//  CompliMap
//
//  Created by Sam Christensen on 5/12/22.
//

import Foundation
import SwiftUI
class Profile {
    private var firstName: String
    private var lastName: String
    private var savedCompliments: [Compliment]
    
    init(firstName:String, lastName:String, savedCompliments:[Compliment]) {
        self.firstName = ""
        self.lastName = ""
        self.savedCompliments = []
    }
}
