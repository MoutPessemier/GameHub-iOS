//
//  User.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

public struct User: Codable {
    
    var id: String?
    var email: String
    var maxDistance: Int
    
    init(id: String?, email: String, maxDistance: Int) {
        self.id = id
        self.email = email
        self.maxDistance = maxDistance
    }
}
