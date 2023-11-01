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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        delegate?.passData(image: imageChosen, name: nameTF.text, phone: phoneTF.text, email: emailTF.text)
        
        if let name = nameTF.text, !name.isEmpty {
            updateDisplayName(name) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else if let email = emailTF.text, !email.isEmpty {
            updateEmail(email) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            self.showAlert(title: "Error", message: "Please provide a name or email.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureView()
    }
    
    func setup() {
        phoneTF.keyboardType = .numberPad
        saveButton.setRoundedBorder(cornerRadius: 20)
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
