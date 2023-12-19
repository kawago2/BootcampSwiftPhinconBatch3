import UIKit
import FirebaseAuth

// MARK: - EditProfileViewControllerDelegate

protocol EditProfileViewControllerDelegate: AnyObject {
    func passData(image: [UIImagePickerController.InfoKey: Any]?, name: String?, phone: String?, email: String?)
}

// MARK: - AuthError

enum AuthError: Error {
    case userNotLoggedIn
    case noUpdatesRequested
}

class EditProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var openCameraButton: UIButton!
    @IBOutlet weak var fromGaleryButton: UIButton!
    @IBOutlet weak var showImageProfile: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Properties
    
    private let pickerImage = UIImagePickerController()
    private var imageChosen = [UIImagePickerController.InfoKey: Any]()
    private var viewModel: EditProfileViewModel!
    
    weak var delegate: EditProfileViewControllerDelegate?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        setInit()
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        phoneTF.keyboardType = .numberPad
        saveButton.setRoundedBorder(cornerRadius: 20)
    }
    
    // MARK: - Setup Init Data
    
    func setInit() {
        nameTF.text = viewModel.userData.nama
        phoneTF.text = viewModel.userData.phone
        emailTF.text = viewModel.userData.email
        showImageProfile.image = UIImage(named: viewModel.userData.image ?? "image_not_available")
    }
    
    // MARK: - Setup Event
    
    func buttonEvent() {
        openCameraButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.openCamera()
        }).disposed(by: disposeBag)
        
        fromGaleryButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.fromGallery()
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.saveTapped()
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Button Actions
    
    private func openCamera() {
        setupImagePicker(sourceType: .camera)
    }
    
    private func fromGallery() {
        setupImagePicker(sourceType: .photoLibrary)
    }
    
    private func setupImagePicker(sourceType: UIImagePickerController.SourceType) {
        pickerImage.allowsEditing = true
        pickerImage.delegate = self
        pickerImage.sourceType = sourceType
        present(pickerImage, animated: true, completion: nil)
    }
    
    private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func saveTapped() {
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

// MARK: - Setup UIImagePicker

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
