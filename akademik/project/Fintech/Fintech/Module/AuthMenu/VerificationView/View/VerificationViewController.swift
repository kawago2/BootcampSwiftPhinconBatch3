import UIKit
import RxSwift

class VerificationViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Properties
    var email: String = ""
    private var viewModel: VerificationViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VerificationViewModel()
        setupUI()
        setupEvent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        openButton.roundCorners(corners: .allCorners, cornerRadius: 30)
        updateEmailLabel()
    }

    private func updateEmailLabel() {
        emailLabel.text = "Check your email \(email) and click the link to verify your email address"
    }
    
    // MARK: - Event Setup
    private func setupEvent() {
        openButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.openMailAction()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Mail Actions
    private func openMailAction() {
        guard let mailURL = viewModel.openMailAction() else {
            return
        }
        
        openURL(mailURL)
    }
    
    private func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: {_ in
                if FirebaseManager.shared.isUserVerified() {
                    self.goToMain()
                } else
                {
                    self.showAlert(title: "Invalid", message: "Please verify your email first.") {
                        self.backToView()
                    }
                    
                }
               
            })
        }
    }
    
    // MARK: - Navigation
    private func goToMain() {
        let maintab = TabBarViewController()
        navigationController?.setViewControllers([maintab], animated: true)
    }
}
