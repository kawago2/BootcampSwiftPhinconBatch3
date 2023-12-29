import UIKit
import RxSwift
import RxCocoa
import DropDown
import FirebaseFirestore

struct PermissionAdd {
    var permissionDate: Date?
    var reason: String?
    var duration: String?
    var type: PermissionType?
}

protocol AddPermissionDelegate {
    func didAddTap(item: PermissionAdd)
}

class AddPermissionViewController: BaseViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var reasonTextField: InputField!
    @IBOutlet weak var durationTextField: InputField!
    @IBOutlet weak var permissionDate: UIDatePicker!
    
    let typeDropDown = DropDown()
    var typeCurrent: PermissionType = .sickLeave
    var delegate: AddPermissionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        bindDatePicker()
        setupDropdown()
    }
    
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
    
    func setupUI() {
        reasonTextField.setup(title: "Reason", placeholder: "", isSecure: false)
        durationTextField.setup(title: "Duration", placeholder: "", isSecure: false)
    }
    
    func bindDatePicker() {
        let minimumDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: Date()) ?? Date()
        Observable.just(minimumDate)
            .bind(to: permissionDate.rx.minimumDate)
            .disposed(by: disposeBag)
    }
    
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

     func showDropdown() {
        typeDropDown.show()
    }
    
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
