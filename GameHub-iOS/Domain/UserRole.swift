//
//  UserRole.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

enum UserRole: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .OWNER
        case 1:
            self = .ADMIN
        case 2:
            self = .USER
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .OWNER:
            try container.encode(0, forKey: .rawValue)
        case .ADMIN:
            try container.encode(1, forKey: .rawValue)
        case .USER:
            try container.encode(2, forKey: .rawValue)
        }
    }
    
    case OWNER
    case ADMIN
    case USER
}
