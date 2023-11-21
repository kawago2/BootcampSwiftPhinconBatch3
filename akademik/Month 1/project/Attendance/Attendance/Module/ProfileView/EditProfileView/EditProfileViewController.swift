import UIKit

protocol EditProfileViewDelegate {
    func didSaveTapped(item: ProfileItem, image: UIImage?)
}

class EditProfileViewController: UIViewController {
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var galeryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nikField: UITextField!
    @IBOutlet weak var alamatField: UITextField!
    @IBOutlet weak var posisiField: UITextField!
    @IBOutlet weak var loadingView: CustomLoading!
    
    var delegate: EditProfileViewDelegate?
    
    var image = "image_not_available"
    var nik = ""
    var alamat = ""
    var name = ""
    var posisi = ""
    var resultImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        buttonEvent()
        setupTextField()
    }
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        saveButton.makeCornerRadius(20)
        cancelButton.makeCornerRadius(20)
        galeryButton.makeCornerRadius(10)
        cameraButton.makeCornerRadius(10)
        profileImage.makeCornerRadius(20)
    }
    
    func setupData() {
        if let url = URL(string: image) {
            profileImage.kf.setImage(with: url)
        } else {
            profileImage.image = UIImage(named: self.image)
        }
        alamatField.text = self.alamat
        nikField.text = self.nik
        nameField.text = self.name
        posisiField.text = self.posisi
    }
    
    func setupTextField() {
        nikField.delegate = self
        nikField.keyboardType = .numberPad
    }
    
    
    func buttonEvent() {
        backgroundButton.addTarget(self, action: #selector(popToView), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(popToView), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        galeryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
    }
    
    @objc func popToView() {
        self.dismiss(animated: true)
    }
    
    @objc func saveTapped() {
        loadingView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let item = ProfileItem(nik: self.nikField.text, alamat: self.alamatField.text, name: self.nameField.text, posisi: self.posisiField.text)
            self.delegate?.didSaveTapped(item: item, image: self.resultImage)
            self.loadingView.stopAnimating()
            self.dismiss(animated: true)
        }

    }
    
    func initData(image: String?, item: ProfileItem?) {
        self.image = image ?? "image_not available"
        guard let item = item else { return }
        self.nik = item.nik ?? ""
        self.alamat = item.alamat ?? ""
        self.name = item.name ?? ""
        self.posisi = item.posisi ?? ""
    }
    
    @objc func openGallery() {
        showImagePicker(sourceType: .photoLibrary)
    }

    @objc func openCamera() {
        showImagePicker(sourceType: .camera)
    }

    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}


extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if string.isEmpty {
            return true
        }
        if let _ = Int(string) {
            return text.count + string.count <= 16
        }
        return false
    }
    
    

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = selectedImage
            resultImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}