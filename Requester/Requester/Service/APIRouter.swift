//
//  APIRouter.swift
//  Requester
//
//  Created by Anton Martsenyuk on 17.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    case text
    case person
    case login(email: String, password: String)
    case logout
    case signup(email: String, password: String, name: String)

    func asURLRequest() throws -> URLRequest {
        let url = try NetworkingConstants.ProductionServer.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.method = method
        
        urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
        
    }


     var method: HTTPMethod {
        switch self {
        case .signup, .logout, .login: return .post
        case .person, .text:           return .get
        }
    }


    private var path: String {
        switch self {
        case .text:   return "/get/text"
        case .person: return "/get/person"
        case .login:  return "/login"
        case .logout: return "/logout"
        case .signup: return "/signup"
        }
    }

    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .signup(let email, let password, let name):
            return ["email": email, "password": password, "name": name]
        case .person, .text, .logout:
            return nil
        }
    }
}
