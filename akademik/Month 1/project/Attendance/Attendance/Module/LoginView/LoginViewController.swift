import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var bottonView: UIView!
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var usernameField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setUsernameField()
        setPasswordField()
        loginButton.setRoundedBorder(cornerRadius: 10)
        bottonView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    func setUsernameField() {
        usernameField.setup(title: "Username", placeholder: "Username", isSecure: false)
        usernameField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        usernameField.titleField.textColor = UIColor(named: "LoginColor")
    }
    
    func setPasswordField() {
        passwordField.setup(title: "Password", placeholder: "Password", isSecure: true)
        passwordField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        passwordField.titleField.textColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.imageView?.tintColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.tintColor = UIColor(named: "LoginColor")
        
        
    }
}

