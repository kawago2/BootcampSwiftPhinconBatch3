import UIKit
import RxSwift
import RxCocoa

class ForgotViewController: UIViewController {
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: ForgotViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        buttonEvent()
    }
    
    func setupViewModel() {
        viewModel = ForgotViewModel()
    }
    
    func buttonEvent() {
        emailField.inputText.rx.text.orEmpty
            .bind(to: viewModel.emailInput)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.resetButtonTap)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.navigateToLogin
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigateToLogin()
            })
            .disposed(by: disposeBag)
        
        viewModel.showAlert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (title, message) in
                guard let self = self else { return }
                self.showAlert(title: title, message: message)
            })
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        setEmailField()
        circleView.tintColor = .white.withAlphaComponent(0.05)
        resetButton.setRoundedBorder(cornerRadius: 10)
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    func setEmailField() {
        emailField.setup(title: "Email", placeholder: "Email", isSecure: false)
        emailField.titleField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        emailField.titleField.textColor = UIColor(named: "LoginColor")
    }
    
    func navigateToLogin() {
        let vc = LoginViewController()
        self.navigationController?.setViewControllers([vc], animated: false)
        
    }
    
}
