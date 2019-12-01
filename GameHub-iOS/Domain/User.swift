//
//  User.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

public struct User: Codable {
    
    var _id: String?
    var email: String
    var maxDistance: Int
    
    init(id _id: String?, email: String, maxDistance: Int) {
        self._id = _id
        self.email = email
        self.maxDistance = maxDistance
    }
}
