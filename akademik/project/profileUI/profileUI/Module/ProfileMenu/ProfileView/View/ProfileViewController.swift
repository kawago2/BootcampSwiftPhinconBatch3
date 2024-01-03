import UIKit
import RxSwift
import FirebaseAuth

class ProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleNavigation: UILabel!
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var penButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: ProfileViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel()
        setupUI()
        getUserData()
        buttonEvent()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        profileImg.image = viewModel.profileImage
        profileImg.setCircleBorder()
        titleNavigation.text = "profile_string".localized
        aboutView.setShadow()
        backButton.isHidden = FAuth.auth.currentUser == nil
    }
    
    // MARK: - Setup Event
    
    private func buttonEvent() {
        backButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.signOutTapped()
        }).disposed(by: disposeBag)
        
        penButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.penButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Get data
    
    private func getUserData() {
        nameTF.text = viewModel.name
        emailTF.text = viewModel.email
        phoneTF.text = viewModel.phone
    }
    
    // MARK: - Navigation
    
    private func signOutTapped() {
        viewModel.signOut { error in
            if let error = error {
                self.showAlert(title: "Error Sign Out", message: error.localizedDescription)
            } else {
                let loginViewController = LoginViewController()
                self.navigationController?.setViewControllers([loginViewController], animated: true)
            }
        }
    }
    
    private func penButtonTapped() {
        let vc = EditProfileViewController()
        vc.delegate = self
        vc.viewModel = EditProfileViewModel(authService: AuthService(), userData: UserModel(nama: viewModel.name, phone: viewModel.phone, email: viewModel.email, image: viewModel.image))
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Edit Profile Delegate

extension ProfileViewController: EditProfileViewControllerDelegate {
    func passData(image: [UIImagePickerController.InfoKey: Any]?, name: String?, phone: String?, email: String?) {
        if let imageDict = image, let validImage = imageDict[.editedImage] as? UIImage {
            profileImg.image = validImage
        }
        
        if let newName = name {
            nameTF.text = newName
        }
        
        if let newPhone = phone {
            phoneTF.text = newPhone
        }
        
        if let newEmail = email {
            emailTF.text = newEmail
        }
    }
}

