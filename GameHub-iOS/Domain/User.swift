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
    var firstName: String
    var lastName: String
    var email: String
    var maxDistance: Int
    var userRole: UserRole
    
    init(id: String?, firstName: String, lastName: String, email: String, maxDistance: Int, userRole: UserRole) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.maxDistance = maxDistance
        self.userRole = userRole
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case email
        case maxDistance
        case userRole
    }
}
