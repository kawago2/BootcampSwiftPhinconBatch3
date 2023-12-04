//
//  LoginViewViewController.swift
//  Fintech
//
//  Created by Phincon on 04/12/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = "Login"
    }
}
