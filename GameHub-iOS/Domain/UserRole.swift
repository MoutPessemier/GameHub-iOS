//
//  UserRole.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

enum UserRole: String, Codable {
    
    case owner = "OWNER"
    case admin = "ADMIN"
    case user = "USER"
}
