//
//  User.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
    var imageURL: URL?
    //var followers: [User]
    //var following: [User]
    
    func addFollower(user: User) {
        
    }
    
    func addFollow(user: User) {
        
    }
}

extension User {
    static let testUser = User(
        id: "",
        name: "Jamie Harris",
        imageURL: URL(string: "https://source.unsplash.com/lw9LrnpUmWw/480x480")
        //followers: [],
        //following: []
    )
}
