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
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
        }

        
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
