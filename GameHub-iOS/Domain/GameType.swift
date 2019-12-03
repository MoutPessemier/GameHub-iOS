//
//  GameTypes.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

enum GameType: String, Codable {
    
    case boardGame = "BOARD_GAME"
    case cardGame = "CARD_GAME"
    case videoGame = "VIDEO_GAME"
    case dnd = "DnD"
    case partyGame = "PARTY_GAME"
    case familyGame = "FAMILY_GAME"
    case unkown = "UNKNOWN"
}
