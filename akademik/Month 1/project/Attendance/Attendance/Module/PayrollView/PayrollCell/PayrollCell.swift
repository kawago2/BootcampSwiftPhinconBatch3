import UIKit


class PayrollCell: UITableViewCell {
    @IBOutlet weak var dateStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var buttonLeadingLabel: UILabel!
    @IBOutlet weak var buttonStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            tableView.isHidden = false
            buttonStack.distribution = .fillProportionally
            downloadButton.isHidden = false
            buttonLeadingLabel.isHidden = false
        } else {
            tableView.isHidden = true
            buttonStack.distribution = .equalCentering
            downloadButton.isHidden = true
            buttonLeadingLabel.isHidden = true
        }
        
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}
