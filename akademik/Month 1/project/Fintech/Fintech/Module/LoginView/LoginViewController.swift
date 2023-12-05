import UIKit
import RxSwift
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupNavigationBar()
        setupInputFields()
        setupButtons()
    }
    
    private func setupNavigationBar() {
        navigationBar.titleNavigationBar = "Login"
    }

    private func setupInputFields() {
        emailField.setup(title: "Email", placeholder: "example@email.com", isSecure: false)
        passwordField.setup(title: "Password", placeholder: "******", isSecure: true)
    }

    private func setupButtons() {
        registerButton.backgroundColor = UIColor(named: "Primary")?.withAlphaComponent(0.10)
        registerButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        loginButton.roundCorners(corners: .allCorners, cornerRadius: 20)
    }

    
    // MARK: - Event Handling
    private func setupEvents() {
        setupLoginButton()
        setupRegisterButton()
    }
    
    private func setupLoginButton() {
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let email = self.emailField.inputText.text, let password = self.passwordField.inputText.text else { return }
            self.viewModel.signInTapped(email: email, password: password) { result in
                self.handleSignInResult(result)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupRegisterButton() {
        registerButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.registerTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Business Logic
    private func handleSignInResult(_ result: Result<AuthDataResult, Error>) {
        switch result {
        case .success(_):
            showAlert(title: "Success", message: "Login successful.")
        case .failure(let error):
            handleSignInError(error)
        }
    }
    
    private func handleSignInError(_ error: Error) {
        if let customError = error as? CustomError, case .customError(let message) = customError {
            showAlert(title: "Error", message: message) {
                self.goToVerif()
            }
        } else {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func registerTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToVerif() {
        let vc = VerificationViewController()
        vc.email = self.emailField.inputText.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
