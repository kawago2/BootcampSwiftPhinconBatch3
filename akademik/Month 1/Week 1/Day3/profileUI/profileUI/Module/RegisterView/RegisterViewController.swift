//
//  RegisterViewController.swift
//  profileUI
//
//  Created by Phincon on 01/11/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var emailField: InputField!
    
    @IBAction func loginTapped(_ sender: Any) {
        let vc = LoginViewController()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        guard let email = emailField.inputText.text, let password = passwordField.inputText.text else {
            // Handle the case where email or password is not valid
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle registration error, such as displaying an alert
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                // User registration successful
                self.showRegistrationSuccessAlert()
            }
        }
    }
    

    func showRegistrationSuccessAlert() {
        let alert = UIAlertController(title: "Register Successful", message: "Please log in to enter the application", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let vc = LoginViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        uiEmailField()
        uiPasswordField()
        registerButton.setRoundedBorder(cornerRadius: 20)
        
    }
    
    func uiEmailField() {
        emailField.self.setShadow(cornerRadius: 10, shadowOpacity: 0.5)
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = FontPoppins.regular(18)
        emailField.inputText.font =  FontPoppins.bold(18)
    }
    
    func uiPasswordField() {
        passwordField.self.setShadow(cornerRadius: 10, shadowOpacity: 0.5)
        passwordField.setup(title: "Password", placeholder: "Password", isSecure: true)
        passwordField.titleField.font = FontPoppins.regular(18)
        passwordField.inputText.font =  FontPoppins.bold(18)
    }
    
}
