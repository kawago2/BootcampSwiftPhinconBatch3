import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var nameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var tosLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    private var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = "Sign Up"
        navigationBar.setupLeadingButton()
        nameField.setup(title: "Name", placeholder: "Loren Ipsum", isSecure: false)
        emailField.setup(title: "Email", placeholder: "example@email.com", isSecure: false)
        passwordField.setup(title: "Password", placeholder: "******", isSecure: true)
        registerButton.backgroundColor = UIColor(named: "Primary")?.withAlphaComponent(0.10)
        nameField.roundCorners(corners: .allCorners, cornerRadius: 20)
        registerButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        loginButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        checkBox.backgroundColor = UIColor.clear
    }
    
    private func setupEvent() {
        registerButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.registerTapped()
        }).disposed(by: disposeBag)
        
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backToLogin()
        }).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backToLogin()
        }).disposed(by: disposeBag)
        
        checkBox.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.checkBoxTapped()
        }).disposed(by: disposeBag)
      
    }
    
    private func checkBoxTapped() {
        isCheck.toggle()
        checkBox.setImage(UIImage(systemName: isCheck ? "checkmark.square.fill" : "square"), for: .normal)
        checkBox.imageView?.contentMode = .scaleAspectFit
    }
    
    private func registerTapped() {
        guard isCheck else {
            showAlert(title: "Invalid", message: "Please read terms of service before register")
            return
        }
        
        let email = emailField.inputText.text ?? ""
        let password = passwordField.inputText.text ?? ""
        viewModel.registerTapped(name: nameField.inputText.text ?? "", email: email, password: password) { result in
            switch result {
            case .success:
                self.showAlert(title: "Success", message: "Register successful") {
                    self.goToVerif()
                }
                
            case .failure(let error):
                self.showAlert(title: "Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func backToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    private func goToVerif() {
        let vc = VerificationViewController()
        vc.email = self.emailField.inputText.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
