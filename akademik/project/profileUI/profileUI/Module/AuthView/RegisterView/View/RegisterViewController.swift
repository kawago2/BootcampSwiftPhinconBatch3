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
    
    var viewModel: RegisterViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    func setupUI() {
        uiEmailField()
        uiPasswordField()
        buttonEvent()
        setupViewModel()
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
    
    func setupViewModel() {
        viewModel = RegisterViewModel()
        viewModel.onRegistrationSuccess = { [weak self] in
            guard let self = self else { return }
            self.showRegistrationSuccessAlert()
        }

        viewModel.onRegistrationFailure = { [weak self] message in
            guard let self = self else { return }
            self.showAlert(title: "Error", message: message)
        }
    }
    
    // MARK: - Button Events
    
    func buttonEvent() {
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
    
    func loginTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Logic Bussiness
    
    func registerTapped() {
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
}
