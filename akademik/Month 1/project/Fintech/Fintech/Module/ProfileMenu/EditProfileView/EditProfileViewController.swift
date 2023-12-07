import UIKit
import RxSwift
import RxCocoa


class EditProfileViewController: BaseViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var phoneField: InputField!
    
    private var userData = UserData()
    private var viewModel = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        initialData()
    }
    
    private func initialData() {
        nameField.inputText.text = userData.name
        emailField.inputText.text = userData.email
        phoneField.inputText.text = userData.phone
        
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = viewModel.titleNavigationBar
        navigationBar.setupLeadingButton()
        saveButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        cameraButton.setCircleNoBorder()
        cameraView.makeCircle()
        userImage.setCircleNoBorder()
        
        nameField.setup(title: "Name", placeholder: "Not set", isSecure: false)
        emailField.setup(title: "Email", placeholder: "Not set", isSecure: false)
        emailField.inputText.isUserInteractionEnabled = false
        emailField.contentView.backgroundColor = .systemGray6
        phoneField.setup(title: "Phone Number", placeholder: "8123456", isSecure: false)
        phoneField.inputText.keyboardType = .numberPad
        phoneField.setupPhoneField()
    }
    
    private func setupEvent() {
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backTapped()
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.saveTapped()
        }).disposed(by: disposeBag)
    }
    
    func recieveData(item: UserData) {
        self.userData = item
    }
    
    private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func saveTapped() {
        guard self.phoneField.inputText.text != "" else {
            return self.showAlert(title: "Invalid", message: "Please input your phone number.")
        }
        self.userData.name = self.nameField.inputText.text
        self.userData.phone = self.phoneField.valueSelected + (self.phoneField.inputText.text ?? "")
        self.viewModel.saveToFirebase(item: self.userData)
        
    }
    

}

