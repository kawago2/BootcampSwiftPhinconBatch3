import UIKit
import RxSwift

class ForgotViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: ForgotViewModel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ForgotViewModel()
        setupUI()
        setupEvent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        navigationBar.titleNavigationBar = "Forgot Password"
        navigationBar.setupLeadingButton()
        emailField.setup(title: "Email", placeholder: "example@email.com", isSecure: false)
        continueButton.roundCorners(corners: .allCorners, cornerRadius: 20)
    }
    
    // MARK: - Event Setup
    private func setupEvent() {
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backToView()
        }).disposed(by: disposeBag)
        
        continueButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.continueTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Business Logic
    private func continueTapped() {
        viewModel.forgotPassword(email: emailField.inputText.text ?? "", completion: {result in
            switch result {
            case .success:
                self.showAlert(title: "Success", message: "Please check your email") {
                    self.backToView()
                }
            case .failure(let error):
                self.showAlert(title: "Failed", message: error.localizedDescription)
            }
        })
    }
}
