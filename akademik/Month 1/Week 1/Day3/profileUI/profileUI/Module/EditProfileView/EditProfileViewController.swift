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
    
    let pickerImage = UIImagePickerController()
    var imageChosen = [UIImagePickerController.InfoKey: Any]()
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    var existingName: String?
    var existingPhone: String?
    var existingEmail: String?
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let newName = nameTF.text, !newName.isEmpty, newName != existingName {
            updateDisplayName(newName) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.updateProfileDataAndPopToRoot(image: self.imageChosen, name: newName, phone: self.phoneTF.text, email: self.emailTF.text)
                }
            }
        } else if let newEmail = emailTF.text, !newEmail.isEmpty, newEmail != existingEmail {
            updateEmail(newEmail) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.updateProfileDataAndPopToRoot(image: self.imageChosen, name: self.nameTF.text, phone: self.phoneTF.text, email: newEmail)
                }
            }
        } else {
            self.updateProfileDataAndPopToRoot(image: self.imageChosen, name: nameTF.text, phone: phoneTF.text, email: emailTF.text)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureView()
        setInit()
    }
    
    func setup() {
        phoneTF.keyboardType = .numberPad
        saveButton.setRoundedBorder(cornerRadius: 20)
    }
    
    func setInit() {
        nameTF.text = existingName
        phoneTF.text = existingPhone
        emailTF.text = existingEmail
    }
    func configureView() {
        openCameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        fromGaleryButton.addTarget(self, action: #selector(fromGallery), for: .touchUpInside)
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
    
    func updateDisplayName(_ displayName: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(AuthError.userNotLoggedIn)
            return
        }

        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.displayName = displayName

        changeRequest.commitChanges { commitError in
            if let commitError = commitError {
                completion(commitError)
            } else {
                completion(nil) // Display name updated successfully
            }
        }
    }

    func updateEmail(_ email: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(AuthError.userNotLoggedIn)
            return
        }

        currentUser.updateEmail(to: email) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil) // Email updated successfully
            }
        }
    }
    
    func updateProfileDataAndPopToRoot(image: [UIImagePickerController.InfoKey: Any]?, name: String?, phone: String?, email: String?) {
        delegate?.passData(image: image, name: name, phone: phone, email: email)
        navigationController?.popToRootViewController(animated: true)
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
