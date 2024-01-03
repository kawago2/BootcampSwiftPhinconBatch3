import UIKit
import RxSwift

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bottonView: UIView!
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        buttonEvent()
    }
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = LoginViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setUsernameField()
        setPasswordField()
        circleView.tintColor = .white.withAlphaComponent(0.05)
        loginButton.setRoundedBorder(cornerRadius: 10)
        bottonView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    private func setUsernameField() {
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        emailField.titleField.textColor = UIColor(named: "LoginColor")
    }
    
    private func setPasswordField() {
        passwordField.setup(title: "Password", placeholder: "***********", isSecure: true)
        passwordField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        passwordField.titleField.textColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.imageView?.tintColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.tintColor = UIColor(named: "LoginColor")
    }
    
    // MARK: - Button Event
    
    private func buttonEvent() {
        emailField.inputText.rx.text.orEmpty
            .bind(to: viewModel.emailInput)
            .disposed(by: disposeBag)
        
        passwordField.inputText.rx.text.orEmpty
            .bind(to: viewModel.passwordInput)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.navigateToTabBar
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigateTabBar()
            })
            .disposed(by: disposeBag)
        
        viewModel.showAlert
            .subscribe(onNext: { [weak self] (title, message) in
                guard let self = self else { return }
                self.showAlert(title: title, message: message)
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.navigateRegister()
        }).disposed(by: disposeBag)
        
        forgotButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigateForgot()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func navigateRegister() {
        if ((navigationController?.viewControllers.first(where: { $0 is RegisterViewController })) != nil) {
            navigationController?.popViewController(animated: true)
        } else {
            let cc = RegisterViewController()
            navigationController?.pushViewController(cc, animated: true)
        }
    }
    
    private func navigateTabBar() {
        let vc = TabBarViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    private func navigateForgot() {
        let vc = ForgotViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

