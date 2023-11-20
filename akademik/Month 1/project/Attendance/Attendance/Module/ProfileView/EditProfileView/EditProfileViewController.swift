import UIKit

protocol EditProfileViewDelegate {
    func didSaveTapped(item: ProfileItem)
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
    
    var delegate: EditProfileViewDelegate?
    
    var image = "image_not_available"
    var nik = ""
    var alamat = ""
    var name = ""
    var posisi = ""
    
    
    
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
        profileImage.image = UIImage(named: self.image)
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
    }
    
    @objc func popToView() {
        self.dismiss(animated: true)
    }
    
    @objc func saveTapped() {
        let item = ProfileItem(nik: nikField.text, alamat: alamatField.text, name: nameField.text, posisi: posisiField.text)
        delegate?.didSaveTapped(item: item)
            dismiss(animated: true)
    }
    
    func initData(image: String, nik: String, alamat: String, name: String, posisi: String) {
        self.image = image
        self.nik = nik
        self.alamat = alamat
        self.name = name
        self.posisi = posisi
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
