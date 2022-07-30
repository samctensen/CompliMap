//
//  OtherProfileViewModel.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/30/22.
//

import Foundation
class OtherProfileViewModel: ObservableObject {
    
    @Published var user: User
    @Published var name: String
    @Published var imageURL: URL?
    
    init(user: User) {
        self.user = user
        self.name = user.name
        imageURL = user.imageURL
    }
}
