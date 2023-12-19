//
//  RegisterViewController.swift
//  profileUI
//
//  Created by Phincon on 01/11/23.
//

import UIKit
import RxSwift
import FirebaseAuth

class RegisterViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: RegisterViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        uiEmailField()
        uiPasswordField()
        buttonEvent()
        setupViewModel()
        registerButton.setRoundedBorder(cornerRadius: 20)
    }
    
    private  func uiEmailField() {
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
    }
    
    private func setupViewModel() {
        viewModel = RegisterViewModel()
        viewModel.onRegistrationSuccess = { [weak self] in
            guard let self = self else { return }
            self.showAlert(title: "Register Successful", message: "Please log in to enter the application") {
                self.loginTapped()
            }
        }
        
        viewModel.onRegistrationFailure = { [weak self] message in
            guard let self = self else { return }
            self.showAlert(title: "Error", message: message)
        }
    }
    
    // MARK: - Button Events
    
    private func buttonEvent() {
        loginButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.loginTapped()
        }).disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.registerTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    private func loginTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Logic Bussiness
    
    private func registerTapped() {
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        viewModel.registerUser(email: email, password: password)
    }
}
