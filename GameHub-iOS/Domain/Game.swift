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
    
    init(id: String, name: String, description:String, rules: String, requirements: String, type: GameType) {
        self.id = id
        self.description = description
        self.name = name
        self.rules = rules
        self.requirements = requirements
        self.type = type
    }
}
