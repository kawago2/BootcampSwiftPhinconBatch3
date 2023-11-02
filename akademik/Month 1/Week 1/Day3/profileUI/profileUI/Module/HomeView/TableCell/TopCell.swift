import UIKit

class TopCell: UITableViewCell {
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }
    
    func setupUI() {
        // Create an array of the buttons
        let buttons = [oneButton, twoButton, threeButton, fourButton]

        for button in buttons {
            // Set rounded border using the custom function
            button?.setRoundedBorder(cornerRadius: 10, borderWidth: 2.0 ,borderColor: UIColor(named: "MainColor") ?? .black)
        }
    }

    
}


