import UIKit
import SHSearchBar


protocol TopCellDelegate {
    func didTapCartButton()
}

class TopCell: UITableViewCell, TopCellDelegate {
    
    @objc func didTapCartButton() {
        self.delegate?.didTapCartButton()
    }
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var searchBar: SearchBar!
    
    var delegate: TopCellDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
        setup()
    }
    
    func setupUI() {
        // Create an array of the buttons
        let buttons = [ filterButton, cartButton]

        for button in buttons {
            // Set rounded border using the custom function
            button?.setRoundedBorder(cornerRadius: 10, borderWidth: 2.0 ,borderColor: UIColor(named: "MainColor") ?? .black)
        }
    }
    
    func setup() {
        searchBar.setup(placeholder: "Searching", isButtonHidden: true)
        cartButton.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
    }

    
}

extension TopCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle text field changes here
        return true
    }
}

