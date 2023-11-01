import UIKit

protocol EditProfileViewControllerDelegate: AnyObject {
    func passData(image:  [UIImagePickerController.InfoKey: Any], name: String, phone: String, email: String)
}

class EditProfileViewController: UIViewController {
    var titlePage = "Edit Profile"
    
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
        delegate?.passData(image: imageChosen, name: nameTF.text ?? "", phone: phoneTF.text ?? "", email: emailTF.text ?? "")
        navigationController?.popToRootViewController(animated: true)
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
