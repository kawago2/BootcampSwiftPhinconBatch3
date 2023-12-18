//
//  PickDateViewController.swift
//  Fintech
//
//  Created by Phincon on 18/12/23.
//

import UIKit
import FSCalendar
import RxSwift

// MARK: - Frequency Enum

enum Frequency: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
}

class PickDateViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var frequencyField: InputField!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var setButton: UIButton!
    
    // MARK: - Properties
    
    private var dropDownManager: DropDownManager!
    private let frequency = ["Weekly", "Monthly"]
    private let initialSelectedIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownManager = DropDownManager(initialSelectedIndex: initialSelectedIndex)
        setupUI()
        setupEvent()
        setupCalendar()
        initialSelect()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        navigationBar.setupLeadingButton(icon: "chevron.down")
        frequencyField.setupWithLogo(title: "Frequency", placeholder: "", icon: "chevron.down")
        frequencyField.inputText.textColor = UIColor(named: ColorName.primary)
        dropDownManager.dropDown.textColor = UIColor(named: ColorName.primary) ?? .black
        dropDownManager.dropDown.selectedTextColor = UIColor(named: ColorName.primary) ?? .black
        setButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        calenderView.roundCorners(corners: .allCorners, cornerRadius: 30)
    }
    
    // MARK: - Event Setup
    
    private func setupEvent() {
        frequencyField.iconButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dropDownLogic()
        }).disposed(by: disposeBag)
    }
    
   
}
// MARK: - Setup FSCalendar Delegate and DataSource

extension PickDateViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    private func setupCalendar() {
        calenderView.delegate = self
        calenderView.dataSource = self
        calenderView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calenderView.appearance.selectionColor = UIColor(named: ColorName.primary)
        calenderView.appearance.borderRadius = 0.5
        calenderView.today = nil
        calenderView.firstWeekday = 2
        calenderView.appearance.weekdayTextColor = .black
        calenderView.scrollEnabled = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: calenderView.frame.width, height: 50))
        headerView.backgroundColor = .white
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .left
        headerLabel.textColor = .black
        headerLabel.font = UIFont(name: FontName.medium, size: 14)
        headerLabel.text = "Pick a start date"
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        calenderView.calendarHeaderView.addSubview(headerView)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        cleanSelectedDates()
        
        let selectedDate = date
        switch getSelectedFrequency() {
        case .weekly:
            if let endDate = Calendar.current.date(byAdding: .day, value: 6, to: selectedDate) {
                selectDates(from: selectedDate, to: endDate)
            }
        case .monthly:
            calenderView.select(selectedDate)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    func cleanSelectedDates() {
        calenderView.selectedDates.forEach {
            calenderView.deselect($0)
        }
    }
    
    func selectDates(from startDate: Date, to endDate: Date) {
        if startDate <= endDate {
            calenderView.select(startDate, scrollToDate: false)
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? .distantFuture
            selectDates(from: nextDate, to: endDate)
        }
    }
    
    private func getSelectedFrequency() -> Frequency {
        let selectedFrequencyText = frequencyField.inputText.text ?? ""
        return Frequency(rawValue: selectedFrequencyText) ?? .monthly
    }
}

// MARK: - Setup DropDown

extension PickDateViewController {
    private func initialSelect() {
        let item = frequency[initialSelectedIndex]
        frequencyField.inputText.text = item
        let result = Frequency(rawValue: item) ?? .monthly
        updatedSelection(result: result)
    }
    
    private func dropDownLogic() {
        self.updateCornerRadius()
        if dropDownManager.isShow {
            dropDownManager.dismissDropDown()
        } else {
            self.dropDownManager.showDropDown(from: self.frequencyField, dataSource: self.frequency) { (index, item) in
                self.frequencyField.inputText.text = item
                let result = Frequency(rawValue: item) ?? .monthly
                self.updatedSelection(result: result)
                self.updateCornerRadius()
            }
        }
    }
    
    private func updateCornerRadius() {
        if dropDownManager.isShow {
            frequencyField.contentView.roundCorners(corners: [.allCorners], cornerRadius: 20)
        } else {
            frequencyField.contentView.roundCorners(corners: [.bottomLeft, .bottomRight], cornerRadius: 0)
            frequencyField.contentView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 20)
        }
    }
    
    private func updatedSelection(result: Frequency) {
        cleanSelectedDates()
        switch result {
        case .weekly:
            self.calenderView.allowsMultipleSelection = true
        case .monthly:
            self.calenderView.allowsMultipleSelection = false
        }
    }
}
