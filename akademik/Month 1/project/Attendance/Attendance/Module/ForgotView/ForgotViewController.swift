//
//  ForgotViewController.swift
//  Attendance
//
//  Created by Phincon on 14/11/23.
//

import UIKit

class ForgotViewController: UIViewController {
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    
    func buttonEvent() {
        loginButton.addTarget(self, action: #selector(navigateToLogin), for: .touchUpInside)
        
    }
    
    @objc func resetTapped() {
        guard let email = emailField.inputText.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please fill email first.")
            return
        }

        FAuth.resetPassword(email: email) { result in
            switch result {
            case .success:
                print("Password reset email sent successfully.")
                self.showAlert(title: "Success", message: "Password reset email sent successfully\nPlease, check your email including spam.")
                self.navigateToLogin()
            case .failure(let error):
                print("Failed to reset password with error: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to reset password. \(error.localizedDescription)")
            }
        }
    }
    
    @objc func navigateToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func setupUI() {
        setEmailField()
        circleView.tintColor = .white.withAlphaComponent(0.05)
        resetButton.setRoundedBorder(cornerRadius: 10)
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    func setEmailField() {
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        emailField.titleField.textColor = UIColor(named: "LoginColor")
    }

}
