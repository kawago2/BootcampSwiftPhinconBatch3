import UIKit


class PayrollCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateStack: UIStackView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var netPayLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    
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
        } else {
            bottomLine.roundCorners(corners: [.topLeft,.topRight], radius: 0)
        }
        
        if last {
            topLine.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 20)
        } else {
            topLine.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 0)
        }
    }
}
