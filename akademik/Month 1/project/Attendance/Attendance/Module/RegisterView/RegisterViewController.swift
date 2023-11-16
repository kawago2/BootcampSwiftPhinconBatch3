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
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    @objc func navigateToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    @objc func registerTapped() {
        let fullname = fullnameField.inputText.text
        let email = emailField.inputText.text
        let password = passwordField.inputText.text
        let repassword = repasswordField.inputText.text
        
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let repassword = repassword, !repassword.isEmpty,
              let fullname = fullname, !fullname.isEmpty else {
                showAlert(title: "Error", message: "Please fill in all fields.")
                return
        }
        
        guard password == repassword else {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        FAuth.registerUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Registrasi berhasil, user: \(user)")
                
                FAuth.updateDisplayName(newName: fullname) { updateResult in
                    switch updateResult {
                    case .success:
                        print("Update display name berhasil")
                    case .failure(let updateError):
                        print("Update display name gagal dengan error: \(updateError.localizedDescription)")
                    }
                }
                self.showAlert(title: "Success", message: "Register Successfuly.")
                self.navigateToLogin()
                
            case .failure(let error):
                print("Registrasi gagal dengan error: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
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
