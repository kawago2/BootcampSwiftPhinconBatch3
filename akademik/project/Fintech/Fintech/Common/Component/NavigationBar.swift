import UIKit

@IBDesignable
class NavigationBar: UIView {

    @IBOutlet weak var leadingView: UIView!
    @IBOutlet weak var leadingButton: UIButton!
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var centerLabel: UILabel!
    
    @IBOutlet weak var trailingView: UIView!
    @IBOutlet weak var trailingButton: UIButton!
    
    var titleNavigationBar = "" {
        didSet {
            centerLabel.text = titleNavigationBar
        }
    }
    
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
        view.backgroundColor = .clear
        self.addSubview(view)
        setupUI()
    }
    
    private func setupUI() {
        leadingButton.isHidden = true
        trailingButton.isHidden = true
        centerLabel.text = titleNavigationBar
    }
    
    func setupLeadingButton(icon: String = "chevron.backward") {
        leadingButton.backgroundColor = UIColor.white
        leadingButton.makeCircle()
        leadingButton.isHidden = false
        leadingButton.setImage(UIImage(systemName: icon), for: .normal)

    }
    
    func setupTrailingButton(icon: String = "chevron.backward") {
        trailingButton.backgroundColor = UIColor.white
        trailingButton.makeCircle()
        trailingButton.isHidden = false
        trailingButton.setImage(UIImage(systemName: icon), for: .normal)

    }
}
