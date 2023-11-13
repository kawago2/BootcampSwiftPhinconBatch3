//
//  LoginViewController.swift
//  profileUI
//
//  Created by Phincon on 31/10/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var emailField: InputField!
    
    @IBAction func registerTapped(_ sender: Any) {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        if signInWithFirebase(email: email, password: password) {
        } else {
            showLoginFailureAlert()
        }
    }
    
    func signInWithFirebase(email: String?, password: String?) -> Bool{
        guard let email = email, let password = password else {
            return false
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showLoginFailureAlert(message: error.localizedDescription)
            } else {
                let vc = TabBarViewController()
                strongSelf.navigationController?.setViewControllers([vc], animated: true)
            }
        }
        return true
    }
    
    func showLoginFailureAlert(message: String? = "Invalid email or password.") {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        uiEmailField()
        uiPasswordField()
        loginButton.setRoundedBorder(cornerRadius: 20)
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
        passwordField.inputText.isSecureTextEntry = true
    }
}
