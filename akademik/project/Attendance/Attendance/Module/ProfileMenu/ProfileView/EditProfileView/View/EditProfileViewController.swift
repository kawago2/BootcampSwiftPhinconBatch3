import UIKit
import RxSwift
import RxCocoa

// MARK: - Protocol

protocol EditProfileViewDelegate: AnyObject {
    func didSaveTapped(item: ProfileItem, image: UIImage?)
}

class EditProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    
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
    
    // MARK: - Properties
    
    private var viewModel: EditProfileViewModel!
    weak var delegate: EditProfileViewDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        buttonEvent()
        setupTextField()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        cardView.makeCornerRadius(20)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        saveButton.makeCornerRadius(20)
        cancelButton.makeCornerRadius(20)
        galeryButton.makeCornerRadius(10)
        cameraButton.makeCornerRadius(10)
        profileImage.makeCornerRadius(20)
    }
    
    // MARK: - Setup View Model
    
    internal func setupViewModel(item: ProfileItem) {
        viewModel = EditProfileViewModel()
        viewModel.image.accept(item.imageUrl != nil ? UIImage(named: item.imageUrl!) : nil)
        viewModel.profile.accept(item)
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        viewModel.image.asObservable().subscribe(onNext: {[weak self] picker in
            guard let self = self else { return }
            self.profileImage.image = picker
        }).disposed(by: disposeBag)
        
        viewModel.profile.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let data = data else { return }
            self.nikField.text = data.nik
            self.alamatField.text = data.alamat
            self.nameField.text = data.name
            self.posisiField.text = data.posisi
            if let url = URL(string: data.imageUrl ?? "") {
                self.profileImage.kf.setImage(with: url)
            } else {
                self.profileImage.image = UIImage(named: Image.notAvail)
            }
            
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Setup Text Field
    
    private func setupTextField() {
        nikField.delegate = self
        nikField.keyboardType = .numberPad
    }
    
    // MARK: - Button Events
    
    private func buttonEvent() {
        backgroundButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.dismissView()
        }).disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.dismissView()
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.saveTapped()
        }).disposed(by: disposeBag)
        
        galeryButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.openGallery()
        }).disposed(by: disposeBag)
        
        cameraButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.openCamera()
        }).disposed(by: disposeBag)
        
    }
    
    private func saveTapped() {
        showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            let item = ProfileItem(
                nik: self.nikField.text,
                alamat: self.alamatField.text,
                name: self.nameField.text,
                posisi: self.posisiField.text
            )
            self.delegate?.didSaveTapped(item: item, image: self.viewModel.image.value)
            self.hideLoading()
            self.dismiss(animated: true)
        }
    }
    
    private func openGallery() {
        showImagePicker(sourceType: .photoLibrary)
    }
    
    private func openCamera() {
        showImagePicker(sourceType: .camera)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
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
            viewModel.image.accept(selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
