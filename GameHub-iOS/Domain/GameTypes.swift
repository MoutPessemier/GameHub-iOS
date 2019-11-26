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
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        
        switch rawValue {
        case 0:
            self = .BOARD_GAME
        case 1:
            self = .CARD_GAME
        case 2:
            self = .VIDEO_GAME
        case 3:
            self = .DnD
        case 4:
            self = .PARTY_GAME
        case 5:
            self = .FAMILY_GAME
        default:
            self = .UNKNOWN
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .BOARD_GAME:
            try container.encode(0, forKey: .rawValue)
        case .CARD_GAME:
            try container.encode(1, forKey: .rawValue)
        case .VIDEO_GAME:
            try container.encode(2, forKey: .rawValue)
        case .DnD:
            try container.encode(3, forKey: .rawValue)
        case .PARTY_GAME:
            try container.encode(4, forKey: .rawValue)
        case .FAMILY_GAME:
            try container.encode(5, forKey: .rawValue)
        default:
            try container.encode(99, forKey: .rawValue)
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
