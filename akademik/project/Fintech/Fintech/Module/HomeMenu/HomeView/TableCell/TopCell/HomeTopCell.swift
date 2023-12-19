import UIKit

class HomeTopCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var ringButton: UIButton!
    @IBOutlet weak var ringView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        captionLabel.textColor = .white.withAlphaComponent(0.80)
        ringButton.roundCorners(corners: .allCorners, cornerRadius: ringButton.frame.height / 2)
        ringButton.tintColor = UIColor(named: ColorName.tint1)
        ringButton.backgroundColor = UIColor(named: ColorName.background5)
        searchButton.roundCorners(corners: .allCorners, cornerRadius: searchButton.frame.height / 2)
        searchButton.tintColor = UIColor(named: ColorName.tint1)
        searchButton.backgroundColor = UIColor(named: ColorName.background5)
    }
    
    public func configureData(userData: UserData?) {
        guard let userData = userData else { return }
        
        if let fullname = userData.name,
           let firstName = fullname.split(separator: " ").first {
            nameLabel.text = "Hello \(firstName)"
        } else {
            nameLabel.text = "Hello"
        }
    }
}
