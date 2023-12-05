import UIKit
import RxSwift

class VerificationViewController: UIViewController {

    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    var email: String = ""
    var context: String = ""
    
    let disposeBag = DisposeBag()

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
        if let mailURL = URL(string: "https://mail.google.com/") {
            openURL(mailURL)
        } else {
            showAlert(title: "Error", message: "Unable to open the mail app.")
        }
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
