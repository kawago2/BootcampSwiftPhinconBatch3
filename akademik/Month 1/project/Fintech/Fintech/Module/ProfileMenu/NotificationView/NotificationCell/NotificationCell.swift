import UIKit

protocol NotificationCellDelegate: AnyObject {
    func switchValueChanged(isOn: Bool)
}


class NotificationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customSwitch: CustomSwitch!
    
    weak var delegate: NotificationCellDelegate?
    
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
    
    func setupName(name: String) {
        nameLabel.text = name
    }
}

extension NotificationCell: CustomSwitchDelegate {
    func switchValueChanged(isOn: Bool) {
        delegate?.switchValueChanged(isOn: isOn)
    }
}


