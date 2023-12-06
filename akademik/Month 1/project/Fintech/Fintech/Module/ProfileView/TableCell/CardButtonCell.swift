import UIKit

class CardButtonCell: UITableViewCell {
    
    
    
    @IBOutlet weak var imageCardView: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
