import UIKit
import DropDown

@IBDesignable
class InputField: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var obsecureButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var areaCodeLabel: UILabel!
    
    // MARK: - Properties
    let areaCodes = ["+1", "+44", "+61", "+81", "+86", "+62"]
    var valueSelected = ""
    var dropDown = DropDown()
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
        setupDropdown()
        dropDown.setupUI(fontSize: 12)
        self.addSubview(view)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         return false
     }

    // MARK: - Dropdown Setup
    func setupDropdown() {
        areaCodeLabel.isHidden = true
        dropDown.anchorView = areaCodeLabel
        dropDown.dataSource = areaCodes
        
        
        // Set initial data
        dropDown.selectRow(selectedAreaCodeIndex)
        let initialAreaCode = areaCodes[selectedAreaCodeIndex]
        areaCodeLabel.text = "(\(initialAreaCode))"
        valueSelected = initialAreaCode
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.areaCodeLabel.text = "(\(item))"
            self.valueSelected = item
        }
    }
    
    // MARK: - Field Configuration
    func setup(title: String, placeholder: String, isSecure: Bool) {
        titleField.text = title
        inputText.placeholder = placeholder
        isObscured = isSecure
        obsecureButton.isHidden = !isSecure
        updateSecureTextEntry()
        setupButton()
    }
    
    // MARK: - Phone Field Configuration
    func setupPhoneField() {
        areaCodeLabel.isHidden = false
    }
    
    // MARK: - Secure Text Entry Update
    func updateSecureTextEntry() {
        inputText.isSecureTextEntry = isObscured
        let iconName = isObscured ? "eye.slash.fill" : "eye.fill"
        obsecureButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    // MARK: - Button Setup
    func setupButton() {
        obsecureButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        areaCodeLabel.isUserInteractionEnabled = true
        let gestureField = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        areaCodeLabel.addGestureRecognizer(gestureField)
    }
    
    // MARK: - Button Tap
    @objc func tapButton() {
        isObscured.toggle()
        updateSecureTextEntry()
    }
    
    // MARK: - Label Tap
    @objc func labelTapped() {
        dropDown.show()
    }
}

extension DropDown {
    func setupUI(fontSize : CGFloat) {
        self.textFont = UIFont(name: "Inter-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        self.backgroundColor = UIColor.white
        self.cornerRadius = 20
        self.selectionBackgroundColor = UIColor.lightGray
    }
}
