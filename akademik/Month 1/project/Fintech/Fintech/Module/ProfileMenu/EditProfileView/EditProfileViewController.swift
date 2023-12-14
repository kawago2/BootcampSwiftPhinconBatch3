import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher


class EditProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var phoneField: InputField!
    
    // MARK: - Properties
    private var userData = UserData()
    private var viewModel: EditProfileViewModel!
    private var imagePicker: UIImagePickerController!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EditProfileViewModel()
        setupUI()
        setupEvent()
        initialData()
        setupPicker()
    }
    
    // MARK: - Initial Setup Methods
    private func initialData() {
        nameField.inputText.text = userData.name
        emailField.inputText.text = userData.email
        phoneField.inputText.text = userData.phone
        if let imageURL = userData.imageURL {
            userImage.kf.setImage(with: imageURL) { result in
                switch result {
                case .success(_):
                    print("success load")
                case .failure(_):
                    self.userImage.image = UIImage(named: CustomImage.notAvailImage)
                }
            }
        } else {
            userImage.image = UIImage(named: CustomImage.notAvailImage)
        }
        
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
        phoneField.setupPhoneField(initialAreaCodeIndex: userData.areaCode)
    }
    
    private func setupPicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    // MARK: - Event Handling
    private func setupEvent() {
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backToView()
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.saveTapped()
        }).disposed(by: disposeBag)
        cameraButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.cameraButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Data Handling
    func recieveData(item: UserData) {
        self.userData = item
    }
    
    // MARK: - Button Actions
    private func cameraButtonTapped() {
        guard let imagePicker = imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func saveTapped() {
        guard self.phoneField.inputText.text != "" else {
            return self.showAlert(title: "Invalid", message: "Please input your phone number.")
        }
        
        
        self.userData.name = self.nameField.inputText.text
        self.userData.phone = self.phoneField.inputText.text
        self.userData.areaCode = self.phoneField.valueSelected
        
        self.viewModel.uploadImageToStorage(userImage: userImage, item: userData) { (metadata, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else if let metadata = metadata {
                print("File uploaded successfully. Metadata: \(metadata)")
                if let path = metadata.path {
                    print("Path: \(path)")
                    self.userData.imagePath = path
                    
                }
                
                self.viewModel.saveToFirebase(item: self.userData, completion: {result in
                    switch result {
                    case .success:
                        self.showAlert(title: "Success", message: "User data save successfuly.") {
                            self.backToView()
                        }
                    case .failure(let error):
                        self.showAlert(title: "Failed", message: error.localizedDescription)
                    }
                })
            }
        }
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userImage.image = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

