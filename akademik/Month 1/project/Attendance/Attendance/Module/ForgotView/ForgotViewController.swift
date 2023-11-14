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
