import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var bottonView: UIView!
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    
    func buttonEvent() {
        registerButton.addTarget(self, action: #selector(navigateRegister), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(navigateForgot), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc func loginTapped() {
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        
        
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
                showAlert(title: "Error", message: "Please fill in all fields.")
                return
        }
        
        FAuth.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Login berhasil, user: \(user)")
                self.navigationController?.setViewControllers([LoginViewController()], animated: true)
                
            case .failure(let error):
                // Handle error login
                print("Login gagal dengan error: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    
    @objc func navigateRegister() {
        let vc = RegisterViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    @objc func navigateTabBar() {
        let vc = TabBarViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    @objc func navigateForgot() {
        let vc = ForgotViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func setupUI() {
        setUsernameField()
        setPasswordField()
        circleView.tintColor = .white.withAlphaComponent(0.05)
        loginButton.setRoundedBorder(cornerRadius: 10)
        bottonView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    func setUsernameField() {
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        emailField.titleField.textColor = UIColor(named: "LoginColor")
    }
    
    func setPasswordField() {
        passwordField.setup(title: "Password", placeholder: "***********", isSecure: true)
        passwordField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        passwordField.titleField.textColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.imageView?.tintColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.tintColor = UIColor(named: "LoginColor")
    }
}

