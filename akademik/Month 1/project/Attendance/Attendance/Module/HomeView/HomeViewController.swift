//
//  HomeViewController.swift
//  Attendance
//
//  Created by Phincon on 14/11/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var bellView: UIImageView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isCheckInLabel: UILabel!
    @IBOutlet weak var isCheckInCircle: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkView: UIView!
    
    let dataArray = [
        ["title": "PT. Phincon", "desc": "Office. 88 @Kasablanka Office Tower 18th Floor"],
        ["title": "Telkomsel Smart Office", "desc": "Jl. Jend. Gatot Subroto Kav. 52. Jakarta Selatan"],
        ["title": "Rumah", "desc": "Jakarta"]
    ]

    
    var isCheckIn = false
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        setupRealTimeClock()
    }
    
    func buttonEvent() {
        isCheckInCircle.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkToggle))
        isCheckInCircle.addGestureRecognizer(tapGesture)
    }
    
    @objc func checkToggle() {
        self.isCheckIn = !isCheckIn
        updateCheck()
    }
    
    func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.05)
        checkView.makeCornerRadius(20)
        updateCheck()
    }
    
    func updateCheck() {
        isCheckInLabel.text = isCheckIn ? "CHECK OUT" : "CHECK IN"
        isCheckInCircle.tintColor = isCheckIn ? UIColor.systemOrange : UIColor.systemGreen
    }
    
    func setupRealTimeClock() {
        updateTimeLabels()

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabels), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeLabels() {
        let currentDate = Date()

        // Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)

        // Format time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let formattedTime = timeFormatter.string(from: currentDate)

        // Update labels
        dateLabel.text = "\(formattedDate)"
        clockLabel.text = "Hour: \(formattedTime)\n"
    }
    
    
}
