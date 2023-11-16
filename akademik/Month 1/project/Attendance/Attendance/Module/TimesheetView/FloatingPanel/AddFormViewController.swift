import UIKit

protocol AddFormViewControllerDelegate {
    func didAddTapped(startDate: Date, endDate: Date, position: String, task: String)
}

class AddFormViewController: UIViewController {
    
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var delegate: AddFormViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        eventButton()
    }
    
    func eventButton() {
        addButton.addTarget(self, action: #selector(didAddTapped), for: .touchUpInside)
    }
    
    @objc func didAddTapped() {
        delegate?.didAddTapped(startDate: startDatePicker.date, endDate: endDatePicker.date, position: positionField.text ?? "", task: taskField.text ?? "")
    }
    
    
    func setupUI() {
        let currentDate = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: currentDate)
        let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate)
        startDatePicker.minimumDate = startDate
        startDatePicker.maximumDate = endDate
        endDatePicker.minimumDate = startDate
        endDatePicker.maximumDate = endDate
    }
}


