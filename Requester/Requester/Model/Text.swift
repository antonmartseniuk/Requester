//
//  Text.swift
//  Requester
//
//  Created by Anton Martsenyuk on 24.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import Foundation

struct Text: Codable {
    let success: Bool
    let data: String?
    let errors: [RequestError]
}
