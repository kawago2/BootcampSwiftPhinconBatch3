import UIKit
import RxGesture

// MARK: - InsightCellDelegate Protocol
protocol InsightCellDelegate: AnyObject {
    func didImageTapped(index: Int?)
}


class InsightCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var userView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    // MARK: - Properties
    private var index: Int?
    weak var delegate: InsightCellDelegate?
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupEvent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        titleLabel.lineBreakMode = .byTruncatingTail
        userView.setCircleWithBorder(borderColor: UIColor(named: ColorName.primary) ?? .black)
    }
    
    // MARK: - Event Setup
    private func setupEvent() {
        userView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.delegate?.didImageTapped(index: self.index)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Data Handling
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func passData(index: Int) {
        self.index = index
    }
    
}
