import UIKit
import RxSwift
import RxCocoa
import DropDown
import FirebaseFirestore

// MARK: - PermissionAdd

struct PermissionAdd {
    var permissionDate: Date?
    var reason: String?
    var duration: String?
    var type: PermissionType?
}

// MARK: - AddPermissionDelegate

protocol AddPermissionDelegate {
    func didAddTap(item: PermissionAdd)
}

// MARK: - AddPermissionViewController

class AddPermissionViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var reasonTextField: InputField!
    @IBOutlet weak var durationTextField: InputField!
    @IBOutlet weak var permissionDate: UIDatePicker!
    
    // MARK: - Properties
    
    let typeDropDown = DropDown()
    var typeCurrent: PermissionType = .sickLeave
    var delegate: AddPermissionDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        bindDatePicker()
        setupDropdown()
    }
    
    // MARK: - Button Event
    
    func buttonEvent() {
        addButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.addTapped()
        }).disposed(by: disposeBag)

        typeLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.showDropdown()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        reasonTextField.setup(title: "Reason", placeholder: "", isSecure: false)
        durationTextField.setup(title: "Duration", placeholder: "", isSecure: false)
    }
    
    // MARK: - Date Picker Binding
    
    func bindDatePicker() {
        let minimumDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: Date()) ?? Date()
        Observable.just(minimumDate)
            .bind(to: permissionDate.rx.minimumDate)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Dropdown Setup
    
    func setupDropdown() {
        typeDropDown.anchorView = typeLabel
        typeDropDown.dataSource = PermissionType.allCases.map { $0.rawValue }
        typeDropDown.setupUI(fontSize: 12)
        typeDropDown.selectRow(0)
        typeLabel.text = typeDropDown.selectedItem
        typeDropDown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            self.typeLabel.text = item
            self.typeCurrent = PermissionType(rawValue: item) ?? .sickLeave
        }
    }

    // MARK: - Show Dropdown
    
    func showDropdown() {
        typeDropDown.show()
    }
    
    // MARK: - Add Button Action
    
    func addTapped() {
        let reasonTextObservable = reasonTextField.inputText.text ?? ""
        let durationTextObservable = durationTextField.inputText.text ?? ""

        if reasonTextObservable.isEmpty && durationTextObservable.isEmpty {
            showAlert(title: "Invalid", message: "Please fill in all fields")
        } else if reasonTextObservable.isEmpty || durationTextObservable.isEmpty{
            showAlert(title: "Invalid", message: "Please fill in fields")
        }
        
        let item = PermissionAdd(permissionDate: permissionDate.date, reason: reasonTextObservable, duration: durationTextObservable, type: self.typeCurrent)
        
        self.delegate?.didAddTap(item: item)
    }
}
