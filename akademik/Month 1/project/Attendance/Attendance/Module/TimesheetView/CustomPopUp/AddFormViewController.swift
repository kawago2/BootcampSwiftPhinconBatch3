import UIKit
import RxSwift
import RxCocoa
import DropDown

enum ThrowError: Error {
    case isPositionEmpty, isTaskEmpty, allEmpty

    func alertPush(controller: UIViewController) {
        var errorMessage = ""
        
        switch self {
        case .isPositionEmpty:
            errorMessage = "Please fill in the Position field"
        case .isTaskEmpty:
            errorMessage = "Please fill in the Task field"
        case .allEmpty:
            errorMessage = "Please fill in both the Position and Task fields"
        }
        controller.showAlert(title: "Invalid Text", message: errorMessage)
    }
}



protocol AddFormViewControllerDelegate {
    func didAddTapped(item : TimesheetItem)
    func didEditTapped(item : TimesheetItem)
}

class AddFormViewController: UIViewController {
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    let dropDown = DropDown()
    
    
    var context = ""
    var documentID = ""
    
    var startInit = Date()
    var endInit = Date()
    var positionInit = ""
    var taskInit = ""
    var statusInit: TaskStatus = .inProgress
    var statusCurrent: TaskStatus = .inProgress
    
    
    private let disposeBag = DisposeBag()
    var delegate: AddFormViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        eventButton()
        setupDropDown()
        context == "edit" ? setupInit() : bindDateValidation()
    }
    
    func eventButton() {
        addButton.addTarget(self, action: #selector(didAddTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        backgroundButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        statusButton.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    }
    
    func setupDropDown() {
        dropDown.anchorView = statusButton
        dropDown.dataSource = TaskStatus.allCases.map { $0.rawValue }
        
        dropDown.setupUI()
        if context == "edit" {
            updateStatusLabel(withStatus: .completed) // Set a default status here
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if let selectedStatus = TaskStatus(rawValue: item) {
                updateStatusLabel(withStatus: selectedStatus)
            }
        }
    }

    func updateStatusLabel(withStatus status: TaskStatus) {
        switch status {
        case .completed:
            self.statusLabel.textColor = UIColor.systemGreen
        case .inProgress:
            self.statusLabel.textColor = UIColor.systemOrange
        case .rejected:
            self.statusLabel.textColor = UIColor.systemRed
        }
        
        self.statusLabel.text = status.rawValue
        self.statusCurrent = status
    }


    
    @objc func showDropDown() {
        dropDown.show()
    }
    
    @objc func didAddTapped() {
        do {
            try checkFields()
            
            switch self.context {
            case "add":
                let item = TimesheetItem(id: "", startDate: startDatePicker.date, endDate: endDatePicker.date, position: positionField.text ?? "", task: taskField.text ?? "", status: statusCurrent)
                  delegate?.didAddTapped(item: item)
            case "edit":
                let item = TimesheetItem( id: documentID, startDate: startDatePicker.date, endDate: endDatePicker.date, position: positionField.text ?? "", task: taskField.text ?? "", status: statusCurrent)
                  delegate?.didEditTapped(item: item)
            default:
                break
            }
            
            dismiss(animated: false)
        } catch let error as ThrowError {
            error.alertPush(controller: self)
        } catch {
            print("Unexpected error: \(error)")
        }
    }



    @objc func cancelTapped() {
        self.dismiss(animated: true)
    }

    func checkFields() throws {
        let isPositionEmpty = positionField.text?.isEmpty ?? true
        let isTaskEmpty = taskField.text?.isEmpty ?? true

        if isPositionEmpty && isTaskEmpty {
            throw ThrowError.allEmpty
        } else if isPositionEmpty {
            throw ThrowError.isPositionEmpty
        } else if isTaskEmpty {
            throw ThrowError.isTaskEmpty
        }
    }


    
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addButton.makeCornerRadius(20)
        addButton.titleLabel?.text = context.capitalized
        cancelButton.makeCornerRadius(20)
        contentView.makeCornerRadius(20)


    }
    
    func initData(startDate: Date, endDate: Date, position: String, task: String, status: TaskStatus) {
        self.startInit = startDate
        self.endInit = endDate
        self.positionInit = position
        self.taskInit = task
        self.statusInit = status
        
        
    }
    
    func setupInit() {
        positionField.text = self.positionInit
        taskField.text = self.taskInit
        startDatePicker.date = self.startInit
        endDatePicker.date = self.endInit
    }
    
    func bindDateValidation() {
        let currentDate = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: currentDate)
        let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate)
        
        startDatePicker.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.endDatePicker.minimumDate = self.startDatePicker.date
            })
            .disposed(by: disposeBag)
        
        endDatePicker.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.startDatePicker.maximumDate = self.endDatePicker.date
            })
            .disposed(by: disposeBag)
        
        startDatePicker.minimumDate = startDate
        startDatePicker.maximumDate = endDate
        endDatePicker.minimumDate = startDatePicker.date
        endDatePicker.maximumDate = endDate
    }
    
}


