import UIKit
import RxSwift
import RxCocoa
import DropDown
import FirebaseFirestore

protocol AddPermissionDelegate {
    func didAddTap()
}

class AddPermissionViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var reasonTextField: InputField!
    @IBOutlet weak var durationTextField: InputField!
    @IBOutlet weak var permissionDate: UIDatePicker!
    
    let disposeBag = DisposeBag()
    let typeDropDown = DropDown()
    var typeCurrent:  PermissionType = .sickLeave
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

    @objc func showDropdown() {
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
        
        

      


        guard let uid = FAuth.auth.currentUser?.uid else { return }
        let documentID = uid
        let inCollection = "permissions"
        let subcollectionPath = "data"
        
        let permission = PermissionForm(
             applicantID: uid,
             type: self.typeCurrent,
             submissionTime: Date(),
             permissionTime: permissionDate.date,
             status: .submitted,
             additionalInfo: PermissionForm.AdditionalInfo(
                reason: reasonTextField.inputText.text,
                duration: durationTextField.inputText.text
             )
         )
        
        let dataPermission = permission.toDictionary()
        
        FFirestore.addDataToSubcollectionWithAutoID(documentID: documentID, inCollection: inCollection, subcollectionPath: subcollectionPath, data: dataPermission) {result in
            switch result {
            case .success:
                print("Data added to subcollection successfully")
                self.showAlert(title: "Success", message: "Form successly created\nPlease wait Approval.", completion: {
                    self.dismiss(animated: true) {
                        self.delegate?.didAddTap()
                    }
                    
                })
            case .failure(let error):
                print("Error adding data to subcollection: \(error.localizedDescription)")
                self.showAlert(title: "Failed", message: error.localizedDescription, completion: {
                    self.dismiss(animated: true)
                })
            }
        }
        
    }
    
}
