//
//  Compliment.swift
//  CompliMap
//
//  Created by Sam Christensen on 5/12/22.
//

import Foundation
class Compliment {
    private var text: String
    // timeStamp and geoTag need better types
    private var timeStamp: Int
    private var geoTag: String
    private var numVotes: Int
    
    init(text:String, timeStamp:Int, geoTag:String, numVotes:Int) {
        self.text = ""
        self.timeStamp = 0
        self.geoTag = ""
        self.numVotes = 0
    }
}
