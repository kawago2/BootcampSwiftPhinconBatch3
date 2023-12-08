import UIKit
import RxSwift

class ResetPasswordViewController: BaseViewController {

    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var oldPasswordField: InputField!
    @IBOutlet weak var newPasswordField: InputField!
    @IBOutlet weak var rePasswordField: InputField!
    @IBOutlet weak var saveButton: UIButton!
    
    let viewModel = ResetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = viewModel.titleNavigationBar
        navigationBar.setupLeadingButton()
        saveButton.roundCorners(corners: .allCorners, cornerRadius: 30)
        
        oldPasswordField.setup(title: "Old Password", placeholder: "Enter old password", isSecure: false)
        newPasswordField.setup(title: "New Password", placeholder: "Enter new password", isSecure: false)
        rePasswordField.setup(title: "Retype New Password", placeholder: "Retype new password", isSecure: false)
    }
    
    private func setupEvent() {
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backToView()
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.saveTapped()
        }).disposed(by: disposeBag)
        
    }
    
    private func saveTapped() {
        guard let oldPassword = oldPasswordField.inputText.text, !oldPassword.isEmpty,
              let newPassword = newPasswordField.inputText.text, !newPassword.isEmpty,
              let retypePassword = rePasswordField.inputText.text, !retypePassword.isEmpty else {
            return showAlert(title: "Invalid", message: "Please fill all fields.")
        }
        
        guard newPassword == retypePassword else {
            return showAlert(title: "Invalid", message: "Password not same.")
        }
        
        viewModel.resetPassword(oldPassword: oldPassword, newPassword: newPassword, completion: { result in
            switch result {
            case .success:
                self.showAlert(title: "Success", message: "Password change successfuly.") {
                    self.backToView()
                }
                
            case .failure(let err):
                self.showAlert(title: "Error", message: err.localizedDescription)
            }
            
        })
    }
}
