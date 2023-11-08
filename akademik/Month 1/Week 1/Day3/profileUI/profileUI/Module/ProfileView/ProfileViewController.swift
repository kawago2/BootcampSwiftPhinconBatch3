import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var titlePage = "profile_string".localized
    let notSetText = "Not Set"
    let defaultText = "No User"
    let image = "image_profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserData()
        setupButton()
    }
    
    func setupButton() {
        backButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        // Set the profile image
        if let image = UIImage(named: image) {
            profileImg.image = image
            profileImg.setCircleBorder()
        }
        
        
        // Set shadow for the aboutView
        aboutView.setShadow()
        if Auth.auth().currentUser == nil {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
    }
    
    func getUserData() {
        guard let user = Auth.auth().currentUser else {
            nameTF.text = defaultText
            phoneTF.text = defaultText
            emailTF.text = defaultText
            return
        }
        
        nameTF.text = user.displayName ?? notSetText
        emailTF.text = user.email ?? notSetText
        phoneTF.text = user.phoneNumber ?? notSetText
    }
    
    @objc func signOutTapped(){
        do {
            try Auth.auth().signOut()
            let loginViewController = LoginViewController()
            navigationController?.setViewControllers([loginViewController], animated: true)
        } catch {
            showAlert(title: "Error Sign Out", message: error.localizedDescription)
        }
    }
    
    @IBAction func penButtonTapped(_ sender: Any) {
        let vc = EditProfileViewController()
        vc.delegate = self
        vc.initData = UserModel(nama: nameTF.text, phone: phoneTF.text, email: emailTF.text, image: image)
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


