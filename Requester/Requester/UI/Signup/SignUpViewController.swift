//
//  SignUpViewController.swift
//  Requester
//
//  Created by Anton Martsenyuk on 17.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    lazy var requestProvider: RequestProvider = {
        return APIClient.shared
    }()
    

    @IBAction func signUpClicked(_ sender: Any) {
        if textValidation() {
            signupRequest(email: emailTextField.text!,
                          password: passwordTextField.text!,
                          userName: nameTextField.text!)
        } else {
            self.validationAlert()
        }
    }
    
    func signupRequest(email: String, password: String, userName: String) {
        requestProvider.signupRequest(email: email, password: password, userName: userName) { user in
            if user.success {
                self.saveToKeychain(user: user)
                self.registeredAlert()
            } else {
                self.alertConfigure(error: user.errors)
            }
        }
    }
}

private extension SignUpViewController {
    func textValidation() -> Bool {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else { return false }
        
        if email.isValidEmail() &&
            password.isValidPassword() && name.isValidName() { return true }
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
    
    func registeredAlert() {
        self.showAlert(withTitle: "Congratulations", message: "You are registered", actionTitle: "Ok") { _ in
            AppUtilities.changeRootVC(UIStoryboard.mainViewController())
        }
    }
    
    
    func alertConfigure(error: [RequestError]) {
        guard let firstError = error.first else {return}
        showAlert(withTitle: firstError.name!.capitalized,
                  message: firstError.message!.capitalized, actionTitle: "Ok")
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
