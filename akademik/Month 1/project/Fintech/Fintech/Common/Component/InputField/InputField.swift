import UIKit

@IBDesignable
class InputField: UIView {
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var obsecureButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    
    var isObscured = false
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
        view.roundCorners(corners: [.allCorners], cornerRadius: 20)
        obsecureButton.tintColor = UIColor(named: "Primary")
        self.addSubview(view)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         return false
     }

    func setup(title: String, placeholder: String, isSecure: Bool) {
        titleField.text = title
        inputText.placeholder = placeholder
        isObscured = isSecure
        obsecureButton.isHidden = !isSecure
        updateSecureTextEntry()
        setupButton()
    }
    
    @objc func tapButton() {
        isObscured.toggle()
        updateSecureTextEntry()
    }
    
    func updateSecureTextEntry() {
        inputText.isSecureTextEntry = isObscured
        let iconName = isObscured ? "eye.slash.fill" : "eye.fill"
        obsecureButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    func setupButton() {
        obsecureButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
}
