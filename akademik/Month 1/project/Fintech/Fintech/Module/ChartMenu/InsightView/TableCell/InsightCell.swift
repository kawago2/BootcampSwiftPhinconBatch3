import UIKit

class InsightCell: UITableViewCell {

    @IBOutlet weak var userView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func setupUI() {
        selectionStyle = .none
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.text = "Bress"
        
        userView.setCircleWithBorder(borderColor: UIColor(named: ColorName.primary) ?? .black)
    }
    
}
