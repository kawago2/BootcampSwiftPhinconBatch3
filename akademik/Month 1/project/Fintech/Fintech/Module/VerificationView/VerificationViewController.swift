import UIKit
import RxSwift

class VerificationViewController: UIViewController {

    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    var email: String = ""
    var context: String = ""
    
    private var viewModel = VerificationViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.backToLogin()
                
            })
        }
    }
    private func backToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
}
