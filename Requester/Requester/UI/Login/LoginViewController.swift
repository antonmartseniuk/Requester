//
//  ViewController.swift
//  Requester
//
//  Created by Anton Martsenyuk on 17.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    lazy var requestProvider: RequestProvider = {
        return APIClient.shared
    }()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

extension LoginViewController {
    @IBAction func signupClicked(_ sender: UIButton) {
        let vc = SignUpViewController.loadFromNib()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        if textValidation() {
            loginRequest(email: emailTextField.text!, password: passwordTextField.text!)
        } else {
            self.validationAlert()
        }
    }
}

private extension LoginViewController {
    func loginRequest(email: String, password: String) {
        requestProvider.loginRequest(email: email, password: password) { user in
            if user.success {
                self.saveToKeychain(user: user)
                AppUtilities.changeRootVC(UIStoryboard.mainViewController())
            } else {
                self.alertConfigure(error: user.errors)
            }
        }
    }
    
    func textValidation() -> Bool {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return false }
        
        if email.isValidEmail() && password.isValidPassword() { return true }
        return false
    }
    
    func saveToKeychain(user: UserRoot) {
        let user = user.data
        
        guard let email = user.email, let token = user.accessToken else { return }
        
        do {
            try KeyChain.saveEmail(data: email)
            try KeyChain.saveToken(data: token)
        } catch {
            print("User data does not save in keychain")
        }
    }
    
    
    func alertConfigure(error: [RequestError]) {
        guard let firstError = error.first else {return}
        showAlert(withTitle: firstError.name!.capitalized,
                  message: firstError.message!.capitalized, actionTitle: "Ok")
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}


class AppUtilities {
    
    class func changeRootVC( _ vc: UIViewController) {
        
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        keyWindow?.rootViewController = vc
        keyWindow?.makeKeyAndVisible()
    }
}
