//
//  RegisterViewController.swift
//  Attendance
//
//  Created by Phincon on 14/11/23.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var fullnameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var repasswordField: InputField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    
    func buttonEvent() {
        loginButton.addTarget(self, action: #selector(navigateToLogin), for: .touchUpInside)
    }
    
    @objc func navigateToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func setupUI() {
        setEmailField()
        setPasswordField()
        setFullnameField()
        setRepasswordField()
        circleView.tintColor = .white.withAlphaComponent(0.05)
        registerButton.setRoundedBorder(cornerRadius: 10)
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    func setEmailField() {
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        emailField.titleField.textColor = UIColor(named: "LoginColor")
    }

    func setFullnameField() {
        fullnameField.setup(title: "Fullname", placeholder: "Fullname", isSecure: false)
        fullnameField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        fullnameField.titleField.textColor = UIColor(named: "LoginColor")
    }
    func setPasswordField() {
        passwordField.setup(title: "Password", placeholder: "***********", isSecure: true)
        passwordField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        passwordField.titleField.textColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.imageView?.tintColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.tintColor = UIColor(named: "LoginColor")
    }
    
    func setRepasswordField() {
        repasswordField.setup(title: "Repeat Passowrd", placeholder: "***********", isSecure: true)
        repasswordField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        repasswordField.titleField.textColor = UIColor(named: "LoginColor")
        repasswordField.obsecureButton.imageView?.tintColor = UIColor(named: "LoginColor")
        repasswordField.obsecureButton.tintColor = UIColor(named: "LoginColor")
    }
}
