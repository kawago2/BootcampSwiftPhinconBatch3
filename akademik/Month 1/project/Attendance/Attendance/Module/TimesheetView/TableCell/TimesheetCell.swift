import UIKit

class TimesheetCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        selectionStyle = .none
        cardView.makeCornerRadius(20)
        colorView.makeCornerRadius(20, maskedCorner: [.layerMinXMinYCorner,.layerMinXMaxYCorner])
    }
    
    func initData(date: String, clock: String, position: String, task: String, status: Int) {
        dateLabel.text = date
        clockLabel.text = clock
        positionLabel.text = position
        taskLabel.text = task
        statusLabel.text = Variables.optionArray[status]
        
        switch status {
        case 0:
            self.colorView.backgroundColor = UIColor.systemGreen
        case 1:
            self.colorView.backgroundColor = UIColor.systemOrange
        case 2:
            self.colorView.backgroundColor = UIColor.systemRed
        default:
            self.colorView.backgroundColor = UIColor.systemGray
        }
    }
    
}
