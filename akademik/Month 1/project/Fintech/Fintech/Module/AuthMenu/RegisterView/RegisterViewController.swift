import UIKit
import RxSwift

class RegisterViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var nameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var tosLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    let viewModel = RegisterViewModel()
    private var isCheck = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        navigationBar.titleNavigationBar = "Sign Up"
        navigationBar.setupLeadingButton()
        nameField.setup(title: "Name", placeholder: "Loren Ipsum", isSecure: false)
        emailField.setup(title: "Email", placeholder: "example@email.com", isSecure: false)
        passwordField.setup(title: "Password", placeholder: "******", isSecure: true)
        registerButton.backgroundColor = UIColor(named: "Primary")?.withAlphaComponent(0.10)
        registerButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        loginButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        checkBox.backgroundColor = UIColor.clear
    }
    
    // MARK: - Event Handling
    private func setupEvent() {
        registerButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.registerTapped()
        }).disposed(by: disposeBag)
        
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backToView()
        }).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backToView()
        }).disposed(by: disposeBag)
        
        checkBox.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.checkBoxTapped()
        }).disposed(by: disposeBag)
      
    }
    
    // MARK: - Business Logic
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
                    self.viewModel.signInTapped(email: email, password: password, completion: {result in
                        switch result {
                        case .success(_):
                            self.goToVerif()
                        case .failure(_):
                            self.showAlert(title: "Invalid", message: "Please restart the application")
                        }
                    })
                }
                
            case .failure(let error):
                self.showAlert(title: "Failed", message: error.localizedDescription)
            }
        }

    }
    
    // MARK: - Navigation
    private func goToVerif() {
        let vc = VerificationViewController()
        vc.email = self.emailField.inputText.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
