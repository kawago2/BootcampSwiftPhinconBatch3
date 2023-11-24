import UIKit
import RxSwift

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
    @IBOutlet weak var toggleButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        buttonEvent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func buttonEvent() {
        toggleButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self  else { return }
            self.reasonLabel.isHidden.toggle()
            self.updateUIButton()
            
            if let tableView = self.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }).disposed(by: disposeBag)
    }
    
    func updateUIButton() {
        if reasonLabel.isHidden {
            toggleButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        } else {
            toggleButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        }
    }
    
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        selectionStyle = .none
        reasonLabel.isHidden = true
    }
    
    func initData(permission: PermissionForm, name: String) {
        nameLabel.text = "Name: " + name
        statusLabel.text = permission.status?.rawValue
        typeLabel.text = permission.type?.rawValue
        
        if let permissionTime = permission.permissionTime {
            permissionDateLabel.text = permissionTime.formattedShortDateString()
            permissionDateLabel.isHidden = false
        } else {
            permissionDateLabel.isHidden = true
        }
        let approvalTime = permission.approvalTime ?? Date()
        switch permission.status {
        case .approved:
            self.approvalDateLabel.isHidden = false
            self.approvalDateLabel.text = approvalTime.formattedShortDateString() + " ✓"
        case .rejected:
            self.approvalDateLabel.isHidden = false
            self.approvalDateLabel.text = approvalTime.formattedShortDateString() + " ✗"
        default:
            self.approvalDateLabel.isHidden = true
        }
        
        
        
        durationLabel.text = "Duration: " + (permission.additionalInfo?.duration ?? "")
        reasonLabel.text = "Reason: " + (permission.additionalInfo?.reason ?? "")
        updateColorView(status: permission.status)
    }
    
    func updateColorView(status: PermissionStatus?) {
        switch status {
        case .approved:
            colorView.backgroundColor = UIColor.systemGreen
        case .rejected:
            colorView.backgroundColor = UIColor.systemRed
        default:
            colorView.backgroundColor = UIColor.systemOrange
        }
    }
    
}
