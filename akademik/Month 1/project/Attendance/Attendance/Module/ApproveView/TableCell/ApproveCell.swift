import UIKit

class ApproveCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var permissionDateLabel: UILabel!
    @IBOutlet weak var approvalDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        cardView.makeCornerRadius(20)
    }
    
    func initData(permission: PermissionForm, name: String) {
        nameLabel.text = name
        statusLabel.text = permission.status?.rawValue
        typeLabel.text = permission.type?.rawValue
        
        if let permissionTime = permission.permissionTime {
            permissionDateLabel.text = permissionTime.formattedShortDateString()
        } else {
            permissionDateLabel.isHidden = true
            
        }
        if let approvalTime = permission.approvalTime {
            approvalDateLabel.text = approvalTime.formattedShortDateString()
        } else {
            approvalDateLabel.isHidden = true
        }
        
        durationLabel.text = permission.additionalInfo?.duration
        reasonLabel.text = permission.additionalInfo?.reason
        updateColorView(status: permission.status)
    }
    
    func updateColorView(status: PermissionStatus?) {
        switch status {
        case .approved:
            colorView.backgroundColor = UIColor.systemGreen
        case .inProgress:
            colorView.backgroundColor = UIColor.systemOrange
        case .rejected:
            colorView.backgroundColor = UIColor.systemRed
        default:
            colorView.backgroundColor = UIColor.gray
        }
    }
    
}
