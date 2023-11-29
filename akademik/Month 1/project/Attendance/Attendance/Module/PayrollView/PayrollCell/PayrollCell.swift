import UIKit


class PayrollCell: UITableViewCell {
    @IBOutlet weak var dateStack: UIStackView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var netPayLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
    }
    
    func initData(date: String, pay: String, month: String ) {
        dateLabel.text = date
        netPayLabel.text = pay
        monthLabel.text = month
    }
    
    
    func configuration(first: Bool, last: Bool) {
        topLine.isHidden = first
        bottomLine.isHidden = last
        
        if first {
            bottomLine.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        }
        
        if last {
            topLine.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 20)
        }
    }

//    func onlyOne() {
//        topLine.isHidden = true
//        bottomLine.roundCorners(corners: [.allCorners], radius: 20)
//    }
    
}
