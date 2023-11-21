import UIKit
import RxCocoa
import RxSwift
class TimesheetCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        buttonEvent()
        updateUIButton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func buttonEvent() {
        toggleButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self  else { return }
            self.taskLabel.isHidden.toggle()
            self.updateUIButton()
            
            if let tableView = self.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }).disposed(by: disposeBag)
    }
    func setupUI() {
        selectionStyle = .none
        cardView.makeCornerRadius(20)
        colorView.makeCornerRadius(20, maskedCorner: [.layerMinXMinYCorner,.layerMinXMaxYCorner])
        taskLabel.isHidden = true
    }
    
    func updateUIButton() {
        if taskLabel.isHidden {
            toggleButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        } else {
            toggleButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        }
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
