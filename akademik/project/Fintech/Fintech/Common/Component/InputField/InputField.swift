import UIKit
import DropDown

@IBDesignable
class InputField: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leadingLabel: UILabel!
    
    // MARK: - Properties
    var valueSelected = ""
    private var dropDown: DropDown!
    private var isObscured = false
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
        contentView.roundCorners(corners: [.allCorners], cornerRadius: 20)
        iconButton.tintColor = UIColor(named: "Primary")
        leadingLabel.isHidden = true
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
        iconButton.isHidden = !isSecure
        updateSecureTextEntry()
        setupButton()
    }

    // MARK: - Button Setup
    func setupButton() {
        iconButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
 
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
        iconButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
}


// MARK: - Template Field with button
extension InputField {
    func setupWithLogo(title: String, placeholder: String, icon: String) {
        titleField.text = title
        inputText.isUserInteractionEnabled = false
        inputText.placeholder = placeholder
        iconButton.setImage(UIImage(named: icon) ?? UIImage(systemName: icon), for: .normal)
    }
}


// MARK: - Templete Phone Field
extension InputField {
    func setupPhoneField(initialAreaCodeIndex: String?) {
        leadingLabel.isHidden = false
        leadingLabel.isUserInteractionEnabled = true
        
        leadingLabel.text = "(" + (initialAreaCodeIndex ?? "+62") + ")"
    }
    
    func setLeadingText(set value: String) {
        leadingLabel.text = "(" + value + ")"
        self.valueSelected = value
    }
}
