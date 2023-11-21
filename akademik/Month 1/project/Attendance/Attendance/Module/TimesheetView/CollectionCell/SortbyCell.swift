import UIKit
import DropDown

protocol SortbyCellDelegate {
    func didLabelTapped(sortby: String)
}

class SortbyCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sortNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let dropDown = DropDown()
    var delegate: SortbyCellDelegate?
    var context = "" {
        didSet {
            setupDropDown()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupDropDown()
        buttonEvent()
    }
    
    func buttonEvent() {
        let sortGes = UITapGestureRecognizer(target: self, action: #selector(didLabelTapped))
        sortNameLabel.addGestureRecognizer(sortGes)
        sortNameLabel.isUserInteractionEnabled = true
    }
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func didLabelTapped() {
         dropDown.show()
     }
    
    func setupDropDown() {
        dropDown.anchorView = sortNameLabel
        if context == "date" {
            dropDown.dataSource = Variables.dateSort
        } else if context == "option" {
            var optionMod = Variables.optionArray
            optionMod.insert(contentsOf: ["Show All"], at: 0)
            dropDown.dataSource = optionMod
        }
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 20
        dropDown.selectionBackgroundColor = UIColor.lightGray

        // Check if the array is not empty before selecting the first row
        if !dropDown.dataSource.isEmpty {
            dropDown.selectRow(0)
            sortNameLabel.text = dropDown.selectedItem
            delegate?.didLabelTapped(sortby: dropDown.selectedItem?.lowercased() ?? "show all")
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.sortNameLabel.text = item
            delegate?.didLabelTapped(sortby: item.lowercased())
        }

    }

    
    func initData(title: String) {
        titleLabel.text = title
    }
}
