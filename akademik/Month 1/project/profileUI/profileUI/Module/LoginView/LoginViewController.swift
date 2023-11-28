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
    @IBOutlet weak var registerButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buttonEvent()
    }
    
    func setup() {
        setupViewModel()
        uiEmailField()
        uiPasswordField()
        loginButton.setRoundedBorder(cornerRadius: 20)
    }
    
    func setupViewModel() {
        viewModel = LoginViewModel()
        viewModel.onLoginSuccess = { [weak self] in
            let vc = TabBarViewController()
            self?.navigationController?.setViewControllers([vc], animated: true)
        }
        
        viewModel.onLoginFailure = { [weak self] message in
            self?.showLoginFailureAlert(message: message)
        }
    }
    
    @objc func registerTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginButtonTapped() {
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        viewModel.signInWithFirebase(email: email, password: password)
    }
    
    func showLoginFailureAlert(message: String? = "Invalid email or password.") {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func buttonEvent() {
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
