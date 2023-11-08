import UIKit
import RxSwift
import RxCocoa

protocol TopCellDelegate {
    func didTapCartButton()
    func didTapFilterButton()
    
}

class TopCell: UITableViewCell {
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var searchBar: SearchBar!
    
    var delegate: TopCellDelegate?
    let disposeBag = DisposeBag()

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
        setup()
    }
    
    
    @objc func didTapCartButton() {
        self.delegate?.didTapCartButton()
    }
    
    @objc func didTapFilterButton() {
        self.delegate?.didTapFilterButton()
    }
    
    
    func setupUI() {
        // Create an array of the buttons
        let buttons = [filterButton, cartButton]
        
        for button in buttons {
            // Set rounded border using the custom function
            button?.setRoundedBorder(cornerRadius: 10, borderWidth: 2.0 ,borderColor: UIColor(named: "MainColor") ?? .black)
        }
    }
    
    func setup() {
        searchBar.setup(placeholder: "Searching", isButtonHidden: true)
        cartButton.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
    }
    
    func inputx(query :String) {
        searchBar.textInput.text = query
    }
}
