//
//  Party.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

public struct Party: Codable {
    
    var id: String?
    var name: String
    var date: Date
    var maxSize: Int = 4
    var participants: [String]
    var gameId: String
    var coordinates: [Double]
    var declines: [String]
    
    init(id:String?, name: String, date: Date, maxSize: Int, participants: [String], gameId: String, coordinates: [Double], declines: [String]) {
        self.id = id
        self.name = name
        self.date = date
        self.maxSize = maxSize
        self.participants = participants
        self.gameId = gameId
        self.coordinates = coordinates
        self.declines = declines
    }
    
}
