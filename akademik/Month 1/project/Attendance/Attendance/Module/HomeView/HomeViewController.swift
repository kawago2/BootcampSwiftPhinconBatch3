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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var circleButton: UIView!
    
    let locationArray = [
        ["title": "PT. Phincon", "desc": "Office. 88 @Kasablanka Office Tower 18th Floor", "img": "id_1"],
        ["title": "Telkomsel Smart Office", "desc": "Jl. Jend. Gatot Subroto Kav. 52. Jakarta Selatan", "img": "id_2"],
        ["title": "Rumah", "desc": "Jakarta", "img": "id_3"]
    ]
    
    var locationSelected: [String: String] = [:]
    var isCheckIn = false
    var timer: Timer?
    var selectedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        setupRealTimeClock()
        setDefaultSelected()
    }
    
    func buttonEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkToggle))
        isCheckInLabel.addGestureRecognizer(tapGesture)
    }

    @objc func checkToggle() {
        self.isCheckIn = !isCheckIn
        updateCheck()
        tableView.reloadData()
        if isCheckIn == false {
            print(self.selectedCell)
            setDefaultSelected()
        }
    }
    
    func setupUI() {
        circleButton.layer.cornerRadius = circleButton.bounds.width / 2.0
        circleButton.clipsToBounds = true
        circleView.tintColor = .white.withAlphaComponent(0.05)
        checkView.makeCornerRadius(20)
        updateCheck()
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateCheck() {
        isCheckInLabel.text = isCheckIn ? "CHECK OUT" : "CHECK IN"
        circleButton.backgroundColor = isCheckIn ? UIColor.systemOrange : UIColor.systemGreen
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
    
    func setDefaultSelected() {
        let defaultIndexPath = IndexPath(row: selectedCell, section: 0)
        tableView.selectRow(at: defaultIndexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: defaultIndexPath)
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCheckIn ? 1 : locationArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let location = isCheckIn ? locationSelected : locationArray[index]
        if isCheckIn {
            let defaultIndexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: defaultIndexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: defaultIndexPath)
        }
        cell.context = isCheckIn ? true : false
        cell.initData(title: location["title"] ?? "", desc: location["desc"] ?? "", img: location["img"] ?? "image_not_available")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCheckIn == false {
            let index = indexPath.row
            self.selectedCell = index
            let locationSelected = locationArray[index]
            self.locationSelected = locationSelected
        }

    }
}
