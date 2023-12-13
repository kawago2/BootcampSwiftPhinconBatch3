import UIKit
import RxSwift

class VerificationViewController: BaseViewController {

    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    var email: String = ""
    var context: String = ""
    
    private var viewModel: VerificationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VerificationViewModel()
        setupUI()
        setupEvent()
    }
    
    private func setupEvent() {
        openButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.openMailAction()
        }).disposed(by: disposeBag)
    }
        
    private func setupUI() {
        openButton.roundCorners(corners: .allCorners, cornerRadius: 30)
        updateEmailLabel()
    }
    
    private func updateEmailLabel() {
        emailLabel.text = "Check your email \(email) and click the link to verify your email address"
    }
    
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
    
    private func goToMain() {
        let maintab = TabBarViewController()
        navigationController?.setViewControllers([maintab], animated: true)
    }
}
