import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var imageeView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var isUseSelected = false
    var context = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if isUseSelected {
            if self.context {
                squareView.backgroundColor = selected ? UIColor.systemOrange : UIColor.white
            } else {
                squareView.backgroundColor = selected ? UIColor(named: "MainColor") : UIColor.white
                titleLabel.textColor = selected ? UIColor.white : UIColor(named: "PrimaryTextColor")
                descLabel.textColor = selected ? UIColor.white : UIColor.black
            }
        }

       
    }
    
    
    func setupUI() {
        squareView.makeCornerRadius(10)
        selectionStyle = .none
    }
    
    func initData(item: InfoItem) {
        titleLabel.text = item.title
        descLabel.text = item.description
        imageeView.image = UIImage(named: item.imageName ?? "image_not_available")
    }
    
    
    
}
