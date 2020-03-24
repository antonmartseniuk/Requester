//
//  RequestError.swift
//  Requester
//
//  Created by Anton Martsenyuk on 24.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import Foundation

struct RequestError: Codable {
    let name: String?
    let message: String?
}
