//
//  PickDateViewController.swift
//  Fintech
//
//  Created by Phincon on 18/12/23.
//

import UIKit
import FSCalendar

class PickDateViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var frequencyField: InputField!
    @IBOutlet weak var calenderView: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCalendar()
    }
    
    private func setupUI() {
        navigationBar.setupLeadingButton(icon: "chevron.down")
        frequencyField.setupWithLogo(title: "Frequency", placeholder: "", icon: "chevron.down")
        calenderView.roundCorners(corners: .allCorners, cornerRadius: 30)
    }
    
    private func setupCalendar() {
        calenderView.delegate = self
        calenderView.dataSource = self
        calenderView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calenderView.appearance.selectionColor = UIColor(named: ColorName.primary)
        calenderView.appearance.borderRadius = 0.5
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
    
}

extension PickDateViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Handle the selected date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = .autoupdatingCurrent
        let formattedDate = dateFormatter.string(from: date)
        print("Selected Date: \(formattedDate)")
    }
    
}
