import UIKit

class CardButtonCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageCardView: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var imageWarpView: UIView!
    
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
        imageWarpView.roundCorners(corners: .allCorners, cornerRadius: 20)
    }
    
    // MARK: - Configuration
    func configureCell(item: CardButton) {
        titlelabel.text = item.title
        imageCardView.image = UIImage(named: item.image ?? CustomImage.notAvailImage)
    }
}
