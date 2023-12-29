import UIKit
import RxSwift


class ApproveCell: UITableViewCell {
    
    // MARK: - Outlets
    
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
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        buttonEvent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        cardView.setShadow()
        colorView.makeCornerRadius(20, maskedCorner: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        selectionStyle = .none
        reasonLabel.isHidden = true
    }
    
    // MARK: - Button Event
    
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
    
    // MARK: - Update UIButton
    
    func updateUIButton() {
        if reasonLabel.isHidden {
            let arrowUpImage = UIImage(systemName: "arrow.up")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            toggleButton.setImage(arrowUpImage, for: .normal)
        } else {
            let arrowDownImage = UIImage(systemName: "arrow.down")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            toggleButton.setImage(arrowDownImage, for: .normal)
        }
    }
    
    
    // MARK: - Initialize Cell Data
    
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
    
    // MARK: - Update Color View
    
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
