//
//  KeyChain.swift
//  Requester
//
//  Created by Anton Martsenyuk on 22.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}

class KeyChain {
    
    private static let passwordKey = "KeyForPassword"
    private static let userAccount = "AuthenticatedUser"
    private static let userEmail   = "KeyForEmail"
    
    
    static func savePassword(data: String) throws {
        try self.save(passwordKey, value: data)
    }
    
    static func saveEmail(data: String) throws {
        try self.delete(userEmail)
        try self.save(userEmail, value: data)
    }
    
    static func saveToken(data: String) throws {
        try self.delete(userAccount)
        try self.save(userAccount, value: data)
    }
    
    static func loadPassword() -> String? {
        return self.load(passwordKey)
    }
    
    static func loadEmail() -> String? {
        return self.load(userEmail)
    }
    
    static func loadToken() -> String? {
        return self.load(userAccount)
    }
}


private extension KeyChain {
    static func save(_ key: String, value: String) throws {
        
        let query = [kSecClass as String       : kSecClassGenericPassword as String,
                     kSecAttrAccount as String : key,
                     kSecValueData as String   : Data(value.utf8) ] as [String : Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unhandledError(status: status)
        }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    
    static func load(_ key: String) -> String? {
        let query = [kSecClass as String       : kSecClassGenericPassword,
                     kSecAttrAccount as String : key,
                     kSecReturnData as String  : kCFBooleanTrue!,
                     kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == noErr else { return nil }
        guard let macData = dataTypeRef as? Data else { return nil }
        return String(bytes: macData, encoding: .utf8)
    }
    
    static func delete(_ key: String) throws {
        let query = [kSecClass as String       : kSecClassGenericPassword,
        kSecAttrAccount as String : key] as [String : Any]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
