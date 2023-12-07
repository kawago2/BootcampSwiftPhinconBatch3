import UIKit
import RxSwift

class EditProfileViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var phoneField: InputField!
    
    private var userData = UserData()
    private let titleNavigationBar = "My Account"
    private let disposeBag = DisposeBag()
    
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
        navigationBar.titleNavigationBar = titleNavigationBar
        navigationBar.setupLeadingButton()
        saveButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        cameraButton.setCircleNoBorder()
        cameraView.makeCircle()
        userImage.setCircleNoBorder()
        
        nameField.setup(title: "Name", placeholder: "Not set", isSecure: false)
        emailField.setup(title: "Email", placeholder: "Not set", isSecure: false)
        emailField.inputText.isUserInteractionEnabled = false
        emailField.contentView.backgroundColor = .systemGray2
        phoneField.setup(title: "Phone Number", placeholder: "+628777777", isSecure: false)
    }
    
    private func setupEvent() {
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backTapped()
        }).disposed(by: disposeBag)
        
    }
    
    func recieveData(item: UserData) {
        self.userData = item
    }
    
    private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    

}

