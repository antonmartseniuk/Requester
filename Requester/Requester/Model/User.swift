//
//  User.swift
//  Requester
//
//  Created by Anton Martsenyuk on 18.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import Foundation

struct UserRoot: Codable {
    let success: Bool
    let data: User
    let errors: [RequestError]
}

struct User: Codable {
    let uid: Int?
    let name: String?
    let email: String?
    let accessToken: String?
    
    enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
        case uid
        case name
        case email
    }
}

