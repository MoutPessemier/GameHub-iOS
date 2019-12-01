//
//  GameTypes.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

enum GameType: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        
        switch rawValue {
        case "BOARD_GAME":
            self = .BOARD_GAME
        case "CARD_GAME":
            self = .CARD_GAME
        case "VIDEO_GAME":
            self = .VIDEO_GAME
        case "DnD":
            self = .DnD
        case "PARTY_GAME":
            self = .PARTY_GAME
        case "FAMILY_GAME":
            self = .FAMILY_GAME
        default:
            self = .UNKNOWN
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .BOARD_GAME:
            try container.encode("BOARD_GAME", forKey: .rawValue)
        case .CARD_GAME:
            try container.encode("CARD_GAME", forKey: .rawValue)
        case .VIDEO_GAME:
            try container.encode("VIDEO_GAME", forKey: .rawValue)
        case .DnD:
            try container.encode("DnD", forKey: .rawValue)
        case .PARTY_GAME:
            try container.encode("PARTY_GAME", forKey: .rawValue)
        case .FAMILY_GAME:
            try container.encode("FAMILY_GAME", forKey: .rawValue)
        default:
            try container.encode("UNKNOWN", forKey: .rawValue)
        }
    }
    
    case BOARD_GAME
    case CARD_GAME
    case VIDEO_GAME
    case DnD
    case PARTY_GAME
    case FAMILY_GAME
    case UNKNOWN
}
