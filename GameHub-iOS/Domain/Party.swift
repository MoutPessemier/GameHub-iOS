//
//  Party.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

public struct Party: Codable {
    
    var _id: String?
    var name: String
//    var date: Date
    var maxSize: Int = 4
    var participants: [String]
    var gameId: String
    var location: Location
    var declines: [String]
    
    init(id _id:String?, name: String, /*date: Date,*/ maxSize: Int, participants: [String], gameId: String, location: Location, declines: [String]) {
        self._id = _id
        self.name = name
//        self.date = date
        self.maxSize = maxSize
        self.participants = participants
        self.gameId = gameId
        self.location = location
        self.declines = declines
    }
    
}
