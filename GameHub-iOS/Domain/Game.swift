//
//  Game.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

public struct Game: Codable {
    
    var id: String?
    var name: String
    var description: String
    var rules: String
    var requirements: String
    var type: GameType
    
    init(id: String?, name:String, description: String, rules: String, requirements: String ,type: GameType) {
        self.id = id
        self.name = name
        self.description = description
        self.rules = rules
        self.requirements = requirements
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case rules
        case requirements
        case type
    }
}
