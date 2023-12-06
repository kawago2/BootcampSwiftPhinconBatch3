import UIKit

class CardButtonCell: UITableViewCell {
    
    @IBOutlet weak var imageCardView: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var imageWarpView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        selectionStyle = .none
        imageWarpView.roundCorners(corners: .allCorners, cornerRadius: 20)
    }
    
    func configureCell(item: CardButton) {
        titlelabel.text = item.title
        imageCardView.image = UIImage(named: item.image ?? CustomImage.notAvailImage)
    }
}
