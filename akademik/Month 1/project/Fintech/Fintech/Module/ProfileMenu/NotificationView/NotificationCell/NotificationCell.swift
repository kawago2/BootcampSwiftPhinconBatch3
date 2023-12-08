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
    
    func setupName(name: String, index: Int) {
        nameLabel.text = name
        self.index = index
    }
}

extension NotificationCell: CustomSwitchDelegate {
    func switchValueChanged(isOn: Bool) {
        delegate?.switchValueChanged(isOn: isOn, index: self.index ?? 99)
    }
}


