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
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        uiEmailField()
        uiPasswordField()
        buttonEvent()
        setupViewModel()
        registerButton.setRoundedBorder(cornerRadius: 20)
    }
    
    func setupViewModel() {
        viewModel = RegisterViewModel()
        viewModel.onRegistrationSuccess = { [weak self] in
            self?.showRegistrationSuccessAlert()
        }

        viewModel.onRegistrationFailure = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
    }
    
    func buttonEvent() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
    }
    
    @objc func loginTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func registerTapped() {
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        viewModel.registerUser(email: email, password: password)
    }
    
    
    func showRegistrationSuccessAlert() {
        let alert = UIAlertController(title: "Register Successful", message: "Please log in to enter the application", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let vc = LoginViewController()
            self?.navigationController?.setViewControllers([vc], animated: true)
        })
        present(alert, animated: true, completion: nil)
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
