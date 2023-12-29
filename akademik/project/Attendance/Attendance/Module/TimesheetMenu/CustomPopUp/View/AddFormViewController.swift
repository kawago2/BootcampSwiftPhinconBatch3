import UIKit
import RxSwift
import RxCocoa
import DropDown

// MARK: - Error Handling

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

// MARK: - Delegate Protocol

protocol AddFormViewControllerDelegate {
    func didAddTapped(item : TimesheetItem)
    func didEditTapped(item : TimesheetItem)
}

class AddFormViewController: BaseViewController {
    
    // MARK: - Outlets
    
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
    
    // MARK: - Properties
    
    internal var viewModel: AddFormViewModel!
    private let dropDown = DropDown()
    var context: Context?
    var delegate: AddFormViewControllerDelegate?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context == .edit ?  () : setupViewModel()
        setupUI()
        setupEvent()
        setupDropDown()
        context == .edit ? setupInit() : bindDateValidation()
    }
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = AddFormViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addButton.makeCornerRadius(20)
        cancelButton.makeCornerRadius(20)
        contentView.makeCornerRadius(20)
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        addButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.didAddTapped()
        }).disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.cancelTapped()
        }).disposed(by: disposeBag)
        
        backgroundButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.cancelTapped()
        }).disposed(by: disposeBag)
        
        statusButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.showDropDown()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func didAddTapped() {
        do {
            try checkFields()
            switch self.context {
            case .add:
                let item = TimesheetItem(id: "", startDate: startDatePicker.date, endDate: endDatePicker.date, position: positionField.text ?? "", task: taskField.text ?? "", status: self.viewModel.statusCurrent)
                  delegate?.didAddTapped(item: item)
            case .edit:
                let item = TimesheetItem(id: viewModel.documentID, startDate: startDatePicker.date, endDate: endDatePicker.date, position: positionField.text ?? "", task: taskField.text ?? "", status: self.viewModel.statusCurrent)
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
    
    private func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Setup Init when context .edit
    
    private func setupInit() {
        positionField.text = self.viewModel.position.value
        taskField.text = self.viewModel.task.value
        startDatePicker.date = self.viewModel.startDate.value
        endDatePicker.date = self.viewModel.endDate.value
        
        startDatePicker.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.endDatePicker.minimumDate = self.startDatePicker.date
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bind Date Validation when context .add
    
    private func bindDateValidation() {
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

// MARK: - Setup DropDown

extension AddFormViewController {
    private func setupDropDown() {
        dropDown.anchorView = statusButton
        dropDown.dataSource = TaskStatus.allCases.map { $0.rawValue }
        
        dropDown.setupUI(fontSize: 12)
        
        if context == .edit {
            updateStatusLabel(withStatus: .completed)
        }
        if context == .add {
            dropDown.selectRow(0)
            updateStatusLabel(withStatus: .completed)
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if let selectedStatus = TaskStatus(rawValue: item) {
                print(selectedStatus)
                updateStatusLabel(withStatus: selectedStatus)
            }
        }
    }

    private func updateStatusLabel(withStatus status: TaskStatus) {
        switch status {
        case .completed:
            self.statusLabel.textColor = UIColor.systemGreen
        case .inProgress:
            self.statusLabel.textColor = UIColor.systemOrange
        case .rejected:
            self.statusLabel.textColor = UIColor.systemRed
        }
        
        self.statusLabel.text = status.rawValue
        self.viewModel.statusCurrent = status
    }

     private func showDropDown() {
        dropDown.show()
    }
}

// MARK: - Check Field with Throw Error

extension AddFormViewController {
    private func checkFields() throws {
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
}
