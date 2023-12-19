//
//  LoginViewController.swift
//  profileUI
//
//  Created by Phincon on 31/10/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupViewModel()
        uiEmailField()
        uiPasswordField()
        loginButton.setRoundedBorder(cornerRadius: 20)
    }
    
    private func uiEmailField() {
        emailField.self.setShadow(cornerRadius: 10, shadowOpacity: 0.5)
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = FontPoppins.regular(18)
        emailField.inputText.font =  FontPoppins.bold(18)
    }
    
    private func uiPasswordField() {
        passwordField.self.setShadow(cornerRadius: 10, shadowOpacity: 0.5)
        passwordField.setup(title: "Password", placeholder: "Password", isSecure: true)
        passwordField.titleField.font = FontPoppins.regular(18)
        passwordField.inputText.font =  FontPoppins.bold(18)
        passwordField.inputText.isSecureTextEntry = true
    }
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = LoginViewModel()
        viewModel.onLoginSuccess = { [weak self] in
            guard let self = self else { return }
            let vc = TabBarViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
        
        viewModel.onLoginFailure = { [weak self] message in
            guard let self = self else { return }
            self.showAlert(title: "Login Failed", message: message)
        }
    }
    
    // MARK: - Button Event
    
    private func buttonEvent() {
        registerButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.registerTapped()
        }).disposed(by: disposeBag)

        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.loginButtonTapped()
        }).disposed(by: disposeBag)
    }

    // MARK: - Navigation
    
    private func registerTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loginButtonTapped() {
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        viewModel.signInWithFirebase(email: email, password: password)
    }
}
