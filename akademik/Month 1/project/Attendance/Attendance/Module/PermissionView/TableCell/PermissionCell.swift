import UIKit
import RxSwift

class PermissionCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var permissionDateLabel: UILabel!
    @IBOutlet weak var approvalDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
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
    
    func setupUI() {
        selectionStyle = .none
        cardView.setShadow()
        colorView.makeCornerRadius(20, maskedCorner: [.layerMinXMaxYCorner,.layerMinXMinYCorner])
        reasonLabel.isHidden = true
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
            let arrowUpImage = UIImage(systemName: "arrow.up")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            toggleButton.setImage(arrowUpImage, for: .normal)
        } else {
            let arrowDownImage = UIImage(systemName: "arrow.down")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            toggleButton.setImage(arrowDownImage, for: .normal)
        }
    }
    
    func initData(permission: PermissionForm) {
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
        case .rejected:
            colorView.backgroundColor = UIColor.systemRed
        default:
            colorView.backgroundColor = UIColor.systemOrange
        }
    }
    
    
}
