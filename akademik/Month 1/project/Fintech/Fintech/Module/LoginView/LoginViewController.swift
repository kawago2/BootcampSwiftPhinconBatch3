import UIKit
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = "Login"
        emailField.setup(title: "Email", placeholder: "example@email.com", isSecure: false)
        passwordField.setup(title: "Password", placeholder: "******", isSecure: true)
        registerButton.backgroundColor = UIColor(named: "Primary")?.withAlphaComponent(0.10)
        registerButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        loginButton.roundCorners(corners: .allCorners, cornerRadius: 20)
    }
    
    private func setupEvent() {
        loginButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.viewModel.signInTapped(email: self.emailField.inputText.text ?? "", password: self.passwordField.inputText.text ?? "") { result in
                switch result {
                case .success(_):
                    self.showAlert(title: "Success", message: "Login successful.")
                    
                case .failure(let error):
                    if let customError = error as? CustomError, case .customError(let message) = customError {
                        self.showAlert(title: "Error", message: message)
                    } else {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.registerTapped()
        }).disposed(by: disposeBag)
    }
    
    private func registerTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
