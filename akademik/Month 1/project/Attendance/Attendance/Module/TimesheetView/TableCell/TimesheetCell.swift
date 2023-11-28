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
        taskLabel.isHidden = true
    }
    
    func updateUIButton() {
        if taskLabel.isHidden {
            let arrowUpImage = UIImage(systemName: "arrow.up")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            toggleButton.setImage(arrowUpImage, for: .normal)
        } else {
            let arrowDownImage = UIImage(systemName: "arrow.down")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            toggleButton.setImage(arrowDownImage, for: .normal)
        }
    }
    
    func initData(date: String, clock: String, position: String, task: String, status: TaskStatus) {
        dateLabel.text = date
        clockLabel.text = clock
        positionLabel.text = position
        taskLabel.text = task
        statusLabel.text = status.rawValue
        colorView.backgroundColor = colorForTaskStatus(status)
    }
    
    
    func colorForTaskStatus(_ taskStatus: TaskStatus) -> UIColor {
        switch taskStatus {
        case .completed:
            return UIColor.systemGreen
        case .inProgress:
            return UIColor.systemOrange
        case .rejected:
            return UIColor.systemRed
        }
    }
}
