import UIKit
import DropDown
import RxSwift
import RxGesture

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
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupDropDown()
        buttonEvent()
    }
    
    func buttonEvent() {
        sortNameLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.didLabelTapped()
        }).disposed(by: disposeBag)
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
            dropDown.dataSource = DateSortOption.allCases.map { $0.rawValue }
        } else if context == "option" {
            var optionMod = TaskStatus.allCases.map { $0.rawValue }
            optionMod.insert(contentsOf: ["Show All"], at: 0)
            dropDown.dataSource = optionMod
        } else if context == "status" {
            var optionMod = PermissionStatus.allCases.map { $0.rawValue }
            optionMod.insert("Show All", at: 0)
            dropDown.dataSource = optionMod
        }
        dropDown.setupUI(fontSize: 12)

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
