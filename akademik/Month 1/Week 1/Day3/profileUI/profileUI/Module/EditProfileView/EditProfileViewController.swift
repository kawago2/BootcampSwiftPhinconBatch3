import UIKit
import FirebaseAuth

protocol EditProfileViewControllerDelegate: AnyObject {
    func passData(image: [UIImagePickerController.InfoKey: Any]?, name: String?, phone: String?, email: String?)
}


enum AuthError: Error {
    case userNotLoggedIn
    case noUpdatesRequested
}

class EditProfileViewController: UIViewController {
    @IBOutlet weak var openCameraButton: UIButton!
    @IBOutlet weak var fromGaleryButton: UIButton!
    @IBOutlet weak var showImageProfile: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let pickerImage = UIImagePickerController()
    var imageChosen = [UIImagePickerController.InfoKey: Any]()
    
    weak var delegate: EditProfileViewControllerDelegate?
    var viewModel: EditProfileViewModel!
    
    //    var initData = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buttonEvent()
        setInit()
    }
    
    func setup() {
        phoneTF.keyboardType = .numberPad
        saveButton.setRoundedBorder(cornerRadius: 20)
    }
    
    func setInit() {
        nameTF.text = viewModel.userData.nama
        phoneTF.text = viewModel.userData.phone
        emailTF.text = viewModel.userData.email
        showImageProfile.image = UIImage(named: viewModel.userData.image ?? "image_not_available")
    }
    
    func buttonEvent() {
        openCameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        fromGaleryButton.addTarget(self, action: #selector(fromGallery), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc func openCamera() {
        setupImagePicker(sourceType: .camera)
    }
    
    @objc func fromGallery() {
        setupImagePicker(sourceType: .photoLibrary)
    }
    
    func setupImagePicker(sourceType: UIImagePickerController.SourceType) {
        pickerImage.allowsEditing = true
        pickerImage.delegate = self
        pickerImage.sourceType = sourceType
        present(pickerImage, animated: true, completion: nil)
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTapped() {
        let newName = nameTF.text ?? ""
        let newEmail = emailTF.text ?? ""
        
        viewModel.updateDisplayName(newName) { nameError in
            if let nameError = nameError {
                self.showAlert(title: "Error", message: nameError.localizedDescription)
            } else {
                self.viewModel.updateEmail(newEmail) { emailError in
                    if let emailError = emailError {
                        self.showAlert(title: "Error", message: emailError.localizedDescription)
                    } else {
                        self.delegate?.passData(image: self.imageChosen, name: newName, phone: self.phoneTF.text, email: newEmail)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
}


extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.showImageProfile.image = image
        self.imageChosen = info
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
