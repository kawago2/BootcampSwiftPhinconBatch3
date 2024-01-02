import UIKit

// MARK: - SliderCell

class SliderCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var image: String?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Methods
    
    func initData(img: String?) {
        if let image = img {
            imageView.image = UIImage(named: image)
        } else {
            imageView.image = UIImage(named: "image_not_available")
        }
    }
}
