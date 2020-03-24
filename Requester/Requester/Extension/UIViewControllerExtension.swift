//
//  UIViewcontrollerExtension.swift
//  Requester
//
//  Created by Anton Martsenyuk on 19.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
    
    func showAlert(withTitle title: String, message: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func validationAlert() {
        showAlert(withTitle: "Incorrect Data", message: "Try again", actionTitle: "OK")
    }
}



