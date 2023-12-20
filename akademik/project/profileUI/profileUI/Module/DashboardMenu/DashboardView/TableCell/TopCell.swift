import UIKit
import RxSwift
import RxCocoa

// MARK: - Protocol

protocol TopCellDelegate: AnyObject {
    func didTapCartButton()
    func textFieldDidChange(_ newText: String)
    
}

class TopCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var searchBar: SearchBar!
    
    // MARK: - Properties
    
    weak var delegate: TopCellDelegate?
    private let disposeBag = DisposeBag()
    private var textSearch = BehaviorRelay<String>(value: "")
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupEvent()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        selectionStyle = .none
        filterButton.setRoundedBorder(cornerRadius: 10, borderWidth: 2.0 ,borderColor: UIColor(named: "MainColor") ?? .black)
        cartButton.setRoundedBorder(cornerRadius: 10, borderWidth: 2.0 ,borderColor: UIColor(named: "MainColor") ?? .black)
        searchBar.setup(placeholder: "Searching", isButtonHidden: true)
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        cartButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.didTapCartButton()
        }).disposed(by: disposeBag)
        
        searchBar.textInput.rx.text.changed.subscribe(onNext: {[weak self] text in
            guard let self = self else { return }
            self.textFieldEditingChanged(self.searchBar.textInput.text ?? "")
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Binding
    
    private func bindToViewModel(textSubject: PublishSubject<String>) {
        searchBar.textInput.rx.text
            .orEmpty
            .subscribe(onNext: { text in
                textSubject.onNext(text)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func didTapCartButton() {
        self.delegate?.didTapCartButton()
    }
    
    private func textFieldEditingChanged(_ searchText: String) {
        delegate?.textFieldDidChange(searchText)
    }
    
}
