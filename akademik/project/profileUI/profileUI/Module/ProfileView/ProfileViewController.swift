import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var penButton: UIButton!
    
    var titlePage = "profile_string".localized
    var viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserData()
        buttonEvent()
    }
    
    func buttonEvent() {
        backButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        penButton.addTarget(self, action: #selector(penButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        profileImg.image = viewModel.profileImage
        profileImg.setCircleBorder()
        
        aboutView.setShadow()
        backButton.isHidden = FAuth.auth.currentUser == nil
    }
    
    func getUserData() {
        nameTF.text = viewModel.name
        emailTF.text = viewModel.email
        phoneTF.text = viewModel.phone
    }
    
    @objc func signOutTapped() {
        viewModel.signOut { error in
            if let error = error {
                self.showAlert(title: "Error Sign Out", message: error.localizedDescription)
            } else {
                let loginViewController = LoginViewController()
                self.navigationController?.setViewControllers([loginViewController], animated: true)
            }
        }
    }
    
    @objc func penButtonTapped() {
        let vc = EditProfileViewController()
        vc.delegate = self
        vc.viewModel = EditProfileViewModel(authService: AuthService(), userData: UserModel(nama: viewModel.name, phone: viewModel.phone, email: viewModel.email, image: viewModel.image))
        navigationController?.pushViewController(vc, animated: true)
    }
}

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

