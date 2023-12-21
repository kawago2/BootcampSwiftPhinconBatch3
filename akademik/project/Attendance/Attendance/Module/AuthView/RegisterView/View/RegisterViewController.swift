import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var fullnameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var repasswordField: InputField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: RegisterViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        buttonEvent()
    }
    
    // MARK: - Setup View Model
    
    private  func setupViewModel() {
        viewModel = RegisterViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setEmailField()
        setPasswordField()
        setFullnameField()
        setRepasswordField()
        circleView.tintColor = .white.withAlphaComponent(0.05)
        registerButton.setRoundedBorder(cornerRadius: 10)
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    private func setEmailField() {
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        emailField.titleField.textColor = UIColor(named: "LoginColor")
    }
    
    private func setFullnameField() {
        fullnameField.setup(title: "Fullname", placeholder: "Fullname", isSecure: false)
        fullnameField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        fullnameField.titleField.textColor = UIColor(named: "LoginColor")
    }
    
    private func setPasswordField() {
        passwordField.setup(title:  "Password", placeholder: "***********", isSecure: true)
        passwordField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        passwordField.titleField.textColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.imageView?.tintColor = UIColor(named: "LoginColor")
        passwordField.obsecureButton.tintColor = UIColor(named: "LoginColor")
    }
    
    private func setRepasswordField() {
        repasswordField.setup(title: "Repeat Passowrd", placeholder: "***********", isSecure: true)
        repasswordField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        repasswordField.titleField.textColor = UIColor(named: "LoginColor")
        repasswordField.obsecureButton.imageView?.tintColor = UIColor(named: "LoginColor")
        repasswordField.obsecureButton.tintColor = UIColor(named: "LoginColor")
    }
    
    // MARK: - Setup Event
    
    private func buttonEvent() {
        
        fullnameField.inputText.rx.text.orEmpty
            .bind(to: viewModel.fullnameInput)
            .disposed(by: disposeBag)
        
        emailField.inputText.rx.text.orEmpty
            .bind(to: viewModel.emailInput)
            .disposed(by: disposeBag)
        
        passwordField.inputText.rx.text.orEmpty
            .bind(to: viewModel.passwordInput)
            .disposed(by: disposeBag)
        
        repasswordField.inputText.rx.text.orEmpty
            .bind(to: viewModel.repasswordInput)
            .disposed(by: disposeBag)
        
        
        loginButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.navigateToLogin()
        }).disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(to: viewModel.registerButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.navigateToLogin
            .subscribe(onNext: { [weak self]  in
                guard let self = self else { return }
                self.navigateToLogin()
            })
            .disposed(by: disposeBag)
        
        viewModel.showAlert
            .subscribe(onNext: { [weak self] (title, message, completion) in
                guard let self = self else { return }
                self.showAlert(title: title, message: message, completion: completion)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func navigateToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
}
