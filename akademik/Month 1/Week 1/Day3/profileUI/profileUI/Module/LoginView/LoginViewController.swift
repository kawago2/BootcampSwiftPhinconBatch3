//
//  LoginViewController.swift
//  profileUI
//
//  Created by Phincon on 31/10/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var emailField: InputField!
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        
        if isValidLogin(email: email, password: password) {
            let vc = TabBarViewController()
            // pass data only
            let profile = ProfileViewController()
            profile.email = email
            navigationController?.setViewControllers([vc], animated: true)
        } else {
            // Handle unsuccessful login (e.g., show an alert)
            let alert = UIAlertController(title: "Login Failed", message: "Invalid email or password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
//            emailField.errorField.text = "Invalid email"
//            passwordField.errorField.text = "Invalid password"
        }
    }
    
    func isValidLogin(email: String?, password: String?) -> Bool {
        return email == "user" && password == "123"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        uiEmailField()
        uiPasswordField()
        topView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 30)
    }
    
    func uiEmailField() {
        emailField.setup(title: "Email", placeholder: "Email")
//        emailField.titleField.text = "Email"
        emailField.inputText.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func uiPasswordField() {
        passwordField.setup(title: "Password", placeholder: "Password")
        passwordField.inputText.font = UIFont.boldSystemFont(ofSize: 20)
    }
}
