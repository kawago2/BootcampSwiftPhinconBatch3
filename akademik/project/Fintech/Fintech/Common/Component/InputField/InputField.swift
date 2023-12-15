import UIKit
import DropDown

@IBDesignable
class InputField: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var obsecureButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var areaCodeLabel: UILabel!
    
    // MARK: - Properties
    let areaCodes = ["+1", "+44", "+61", "+81", "+86", "+62"]
    var valueSelected = ""
    var dropDown: DropDown!
    var isObscured = false
    private var selectedAreaCodeIndex = 0
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - View Configuration
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
        view.roundCorners(corners: [.allCorners], cornerRadius: 20)
        obsecureButton.tintColor = UIColor(named: "Primary")
        areaCodeLabel.isHidden = true
        self.addSubview(view)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         return false
     }
}


// MARK: - Templete Password Field OR Normal Field
extension InputField {
    
    // MARK: - Field Configuration
    func setup(title: String, placeholder: String, isSecure: Bool = false) {
        titleField.text = title
        inputText.placeholder = placeholder
        isObscured = isSecure
        obsecureButton.isHidden = !isSecure
        updateSecureTextEntry()
        setupButton()
    }

    // MARK: - Button Setup
    func setupButton() {
        obsecureButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
 
    }
    
    // MARK: - Button Tap
    @objc func tapButton() {
        isObscured.toggle()
        updateSecureTextEntry()
    }
    
    // MARK: - Secure Text Entry Update
    func updateSecureTextEntry() {
        inputText.isSecureTextEntry = isObscured
        let iconName = isObscured ? "eye.slash.fill" : "eye.fill"
        obsecureButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
}


// MARK: - Template Field with button
extension InputField {
    func setupWithLogo(title: String, placeholder: String, iconButton: String) {
        titleField.text = title
        inputText.placeholder = placeholder
        obsecureButton.setImage(UIImage(named: iconButton) ?? UIImage(systemName: iconButton), for: .normal)
    }
}


// MARK: - Templete Phone Field
extension InputField {
//    func searchIndex(for searchString: String) -> Int? {
//        if let index = areaCodes.firstIndex(where: { $0.contains(searchString) }) {
//            return index
//        } else {
//            return nil
//        }
//    }

    func setupPhoneField(initialAreaCodeIndex: String = "") {
        areaCodeLabel.isHidden = false
        areaCodeLabel.text = initialAreaCodeIndex
    }
    
    
//
//    func setupButtonDD() {
//        areaCodeLabel.isUserInteractionEnabled = true
//        let gestureField = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
//        areaCodeLabel.addGestureRecognizer(gestureField)
//    }
//
//    // MARK: - Dropdown Setup
//    func setupDropdownPhone() {
//        dropDown = DropDown()
//        areaCodeLabel.isHidden = true
//        dropDown.anchorView = areaCodeLabel
//        dropDown.dataSource = areaCodes
//
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.areaCodeLabel.text = "(\(item))"
//            self.valueSelected = item
//        }
//    }

//    // MARK: - Label Tap
//    @objc func labelTapped() {
//        dropDown.show()
//    }
}

