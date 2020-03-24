//
//  APIClient.swift
//  Requester
//
//  Created by Anton Martsenyuk on 18.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import Alamofire

protocol RequestProvider {
    func loginRequest(email: String, password: String, completion: @escaping (UserRoot) -> Void)
    func signupRequest(email: String, password: String, userName: String, completion: @escaping (UserRoot) -> Void)
    func getText(token: String, completion: @escaping (Text) -> Void)
}


class APIClient {
    static let shared = APIClient()
}

extension APIClient: RequestProvider {
    func loginRequest(email: String, password: String, completion: @escaping (UserRoot) -> Void) {
        AF.request("http://apiecho.cf/api/login/",
                   method: .post,
                   parameters: ["email": email, "password": password]).response { response in
                    
                    switch response.result {
                    case .success(let data): self.decode(data: data, type: UserRoot.self) { user in
                        completion(user)
                        }
                    case .failure(let error): print("ERROR \(error)")
                    }
        }
    }
    
    func signupRequest(email: String, password: String, userName: String, completion: @escaping (UserRoot) -> Void) {
        AF.request("http://apiecho.cf/api/signup/", method: .post,
                   parameters: ["email": email, "password":password, "name": userName]).response { response in
                    
                    switch response.result {
                    case .success(let data): self.decode(data: data, type: UserRoot.self) { user in
                        completion(user)
                        }
                    case .failure(let error): print("ERROR \(error)")
                    }
        }
    }
    
    func getText(token: String, completion: @escaping (Text) -> Void) {
        AF.request("http://apiecho.cf/api/get/text/",
                   headers: ["Authorization":"Bearer \(token)"]).response { response in
                    
                    switch response.result {
                    case .success(let data): self.decode(data: data, type: Text.self) { text in
                        completion(text)
                        }
                    case .failure(let error): print("ERROR \(error)")
                    }
        }
    }
}

private extension APIClient {
    func decode<T: Codable>(data: Data?, type: T.Type, completion: @escaping (T) -> Void) {
        guard let data = data else {return}
        
        do {
            let model = try JSONDecoder().decode(type, from: data)
            completion(model)
        } catch let error {
            print("failed to decode, \(error)")
            return
        }
    }
}

