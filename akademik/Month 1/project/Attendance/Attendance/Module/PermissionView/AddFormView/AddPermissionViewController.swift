import UIKit
import RxSwift
import RxCocoa
import DropDown
import FirebaseFirestore

class AddPermissionViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var reasonTextField: InputField!
    @IBOutlet weak var durationTextField: InputField!
    @IBOutlet weak var permissionDate: UIDatePicker!
    
    let disposeBag = DisposeBag()
    let typeDropDown = DropDown()
    var typeCurrent:  PermissionType = .sickLeave
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
            print("apakek")
            
        }).disposed(by: disposeBag)
        
        let typeGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdown))
        typeLabel.isUserInteractionEnabled = true
        typeLabel.addGestureRecognizer(typeGesture)
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
        
        FFirestore.addDataToSubcollection(documentID: documentID, inCollection: inCollection, subcollectionPath: subcollectionPath, data: dataPermission) {result in
            switch result {
            case .success:
                print("Data added to subcollection successfully")
                self.showAlert(title: "Success", message: "Form successly created\nPlease wait Approval.", completion: {
                    self.dismiss(animated: true)
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
