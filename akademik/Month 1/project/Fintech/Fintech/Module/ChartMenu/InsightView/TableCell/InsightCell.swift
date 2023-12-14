import UIKit
import RxGesture

class InsightCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var userView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    // MARK: - Properties
    private var index: Int?
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
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
    
    // MARK: - Data Handling
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func passData(index: Int) {
        self.index = index
    }
    
}
