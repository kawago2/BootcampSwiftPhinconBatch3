import UIKit

class CustomEmpty: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Medium", size: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    // Add any additional UI elements as needed
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(titleLabel)
        
        // Configure the layout constraints for titleLabel and other UI elements
        
        // Example:
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        titleLabel.text = "Data is Empty"
        hide()
    }

    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
