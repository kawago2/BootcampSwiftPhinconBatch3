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
    
    var initData = UserModel()
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let newName = nameTF.text ?? ""
           let newEmail = emailTF.text ?? ""

           if (newName != initData.nama) && (newEmail != initData.email) {
               // Kedua nama dan email berubah, lakukan pembaruan untuk keduanya
               updateDisplayName(newName) { nameError in
                   if let nameError = nameError {
                       self.showAlert(title: "Error", message: nameError.localizedDescription)
                   } else {
                       self.updateEmail(newEmail) { emailError in
                           if let emailError = emailError {
                               self.showAlert(title: "Error", message: emailError.localizedDescription)
                           } else {
                               self.updateProfileDataAndPopToRoot(image: self.imageChosen, name: newName, phone: self.phoneTF.text, email: newEmail)
                           }
                       }
                   }
               }
           } else if newName != initData.nama {
               // Hanya nama yang berubah, lakukan pembaruan nama
               updateDisplayName(newName) { nameError in
                   if let nameError = nameError {
                       self.showAlert(title: "Error", message: nameError.localizedDescription)
                   } else {
                       self.updateProfileDataAndPopToRoot(image: self.imageChosen, name: newName, phone: self.phoneTF.text, email: newEmail)
                   }
               }
           } else if newEmail != initData.email {
               // Hanya email yang berubah, lakukan pembaruan email
               updateEmail(newEmail) { emailError in
                   if let emailError = emailError {
                       self.showAlert(title: "Error", message: emailError.localizedDescription)
                   } else {
                       self.updateProfileDataAndPopToRoot(image: self.imageChosen, name: newName, phone: self.phoneTF.text, email: newEmail)
                   }
               }
           } else {
               // Tidak ada perubahan yang perlu dilakukan
               self.updateProfileDataAndPopToRoot(image: self.imageChosen, name: newName, phone: self.phoneTF.text, email: newEmail)
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
        nameTF.text = initData.nama
        phoneTF.text = initData.phone
        emailTF.text = initData.email
        // Set the profile image
        if let image = UIImage(named: initData.image ?? "image_not_available") {
            showImageProfile.image = image
        }

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
