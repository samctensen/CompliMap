//
//  CompliMapApp.swift
//  CompliMap
//
//  Created by Sam Christensen on 5/4/22.
//

import SwiftUI
import Firebase

@main
struct CompliMapApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
