import UIKit

// MARK: - NotificationCellDelegate Protocol
protocol NotificationCellDelegate: AnyObject {
    func switchValueChanged(isOn: Bool, index: Int)
}

// MARK: - NotificationCell
class NotificationCell: BaseTableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customSwitch: CustomSwitch!
    
    // MARK: - Properties
    weak var delegate: NotificationCellDelegate?
    private var index: Int?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        customSwitch.delegate = self
        selectionStyle = .none
    }
    
    // MARK: - Configuration
    func setupConfigure(name: String, index: Int, isOn: Bool) {
        nameLabel.text = name
        self.index = index
        self.customSwitch.setOn(isOn, animated: true)
    }
}

// MARK: - CustomSwitchDelegate
extension NotificationCell: CustomSwitchDelegate {
    func switchValueChanged(isOn: Bool) {
        delegate?.switchValueChanged(isOn: isOn, index: self.index ?? 99)
    }
}


