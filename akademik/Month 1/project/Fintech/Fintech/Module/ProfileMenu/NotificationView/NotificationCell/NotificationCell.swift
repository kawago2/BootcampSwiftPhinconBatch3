import UIKit

protocol NotificationCellDelegate: AnyObject {
    func switchValueChanged(isOn: Bool, index: Int)
}


class NotificationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customSwitch: CustomSwitch!
    
    weak var delegate: NotificationCellDelegate?
    private var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        customSwitch.delegate = self
        selectionStyle = .none
    }
    
    func setupConfigure(name: String, index: Int, isOn: Bool) {
        nameLabel.text = name
        self.index = index
        self.customSwitch.setOn(isOn, animated: true)
    }
}

extension NotificationCell: CustomSwitchDelegate {
    func switchValueChanged(isOn: Bool) {
        delegate?.switchValueChanged(isOn: isOn, index: self.index ?? 99)
    }
}


