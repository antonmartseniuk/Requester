//
//  StringExtension.swift
//  Requester
//
//  Created by Anton Martsenyuk on 22.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        
        guard !self.isEmpty else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: self)
    }
    
    
    func isValidPassword() -> Bool {
        guard !self.isEmpty else { return false }
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        guard !self.isEmpty else { return false }
        let RegEx = "^\\w{4,18}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
}
