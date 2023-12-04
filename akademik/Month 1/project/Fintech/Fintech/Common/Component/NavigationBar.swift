import UIKit

@IBDesignable
class NavigationBar: UIView {

    @IBOutlet weak var leadingView: UIView!
    @IBOutlet weak var leadingButton: UIButton!
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var centerLabel: UILabel!
    
    @IBOutlet weak var trailingView: UIView!
    @IBOutlet weak var trailingButton: UIButton!
    
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
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         return false
     }
}
