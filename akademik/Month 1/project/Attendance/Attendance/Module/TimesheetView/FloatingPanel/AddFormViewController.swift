import UIKit
import RxSwift
import RxCocoa


protocol AddFormViewControllerDelegate {
    func didAddTapped(startDate: Date, endDate: Date, position: String, task: String)
}

class AddFormViewController: UIViewController {
    
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    
    private let disposeBag = DisposeBag()
    var delegate: AddFormViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        eventButton()
        bindDateValidation()
    }
    
    func eventButton() {
        addButton.addTarget(self, action: #selector(didAddTapped), for: .touchUpInside)
    }
    
    @objc func didAddTapped() {
        guard checkFields() else { return }
        
        delegate?.didAddTapped(startDate: startDatePicker.date, endDate: endDatePicker.date, position: positionField.text ?? "", task: taskField.text ?? "")
    }

    func checkFields() -> Bool {
        let isPositionEmpty = positionField.text?.isEmpty ?? true
        let isTaskEmpty = taskField.text?.isEmpty ?? true

        if isPositionEmpty || isTaskEmpty {
            var errorMessage = ""
            
            if isPositionEmpty && isTaskEmpty {
                errorMessage = "Please fill in both the Position and Task fields"
            } else if isPositionEmpty {
                errorMessage = "Please fill in the Position field"
            } else {
                errorMessage = "Please fill in the Task field"
            }
            
            showAlert(title: "Invalid Text", message: errorMessage)
            return false
        }
        
        return true
    }

    
    
    func setupUI() {

    }
    
    func bindDateValidation() {
        let currentDate = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: currentDate)
        let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate)
        
        startDatePicker.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.endDatePicker.minimumDate = self?.startDatePicker.date
            })
            .disposed(by: disposeBag)
        
        endDatePicker.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.startDatePicker.maximumDate = self?.endDatePicker.date
            })
            .disposed(by: disposeBag)
        
        startDatePicker.minimumDate = startDate
        startDatePicker.maximumDate = endDate
        endDatePicker.minimumDate = startDatePicker.date
        endDatePicker.maximumDate = endDate
    }
    
}


