//
//  HistoryViewController.swift
//  Attendance
//
//  Created by Phincon on 14/11/23.
//

import UIKit
import FirebaseFirestore

class HistoryViewController: UIViewController {
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    
    var allData: [InfoItem] = []
    var allDataHistory: [HistoryItem] = []
    var filteredData: [HistoryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        fetchData()
        dayButtonTapped()
    }
    
    
    
    func buttonEvent() {
        dayButton.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(weekButtonTapped), for: .touchUpInside)
        monthButton.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
    }
    
    @objc func dayButtonTapped() {
        dayButton.isSelected = true
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = false
        filterData(by: .day)
    }

    @objc func weekButtonTapped() {
        dayButton.isSelected = false
        weekButton.isSelected = true
        monthButton.isSelected = false
        yearButton.isSelected = false
        filterData(by: .weekOfYear)
    }

    @objc func monthButtonTapped() {
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = true
        yearButton.isSelected = false
        filterData(by: .month)
    }

    @objc func yearButtonTapped() {
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = true
        filterData(by: .year)
    }
    
    func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.05)
        bottomView.makeCornerRadius(20)
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchData() {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "history"
        
        FFirestore.getDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath) { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    if let data = document.data() {
                        let date = data["checkTime"] as? Timestamp
                        let isCheck = data["isCheck"] as? Bool ?? false
                        let title = data["titleLocation"] as? String ?? "DefaultTitle"
                        let description = data["descLocation"] as? String ?? "DefaultDescription"
                        let imageName = data["image"] as? String ?? "DefaultImage"
                        
                        let checkString = isCheck ? "Check In" : "Check Out"
                        
                        // Format time with AM/PM
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "hh:mm a"
                        let formattedTime = timeFormatter.string(from: date?.dateValue() ?? Date())

                        let infoItem = InfoItem(title: "\(checkString) - \(title) - \(formattedTime)", description: description, imageName: imageName)
                        let historyItem = HistoryItem(checkTime: date?.dateValue(), descLocation: description, image: imageName, isCheck: isCheck, titleLocation: title)
                        self.allData.append(infoItem)
                        self.allDataHistory.append(historyItem)
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                print("Error getting data from subcollection: \(error.localizedDescription)")
            }
        }
    }
    
    func filterData(by component: Calendar.Component) {
        let currentDate = Date()
        let calendar = Calendar.current
        let filteredDate = calendar.date(byAdding: component, value: -1, to: currentDate) ?? Date()

        filteredData = allDataHistory.filter { item in
            if let checkTime = item.checkTime {
                return checkTime > filteredDate
            }
            return true
        }
        tableView.reloadData()
    }


}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.isEmpty { return allData.isEmpty ? 1 : allData.count}
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        if allData.isEmpty {
            return cell
        } else {
            if filteredData.isEmpty {
                let fetch = allData[index]
                cell.initData(title: fetch.title ?? "", desc: fetch.description ?? "", img: fetch.imageName ?? "image_not_available")
                return cell
            } else {
                let filter = filteredData[index]
                
                let checkString = filter.isCheck ?? false ? "Check In" : "Check Out"
                
                // Format time with AM/PM
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm a"
                let formattedTime = timeFormatter.string(from: filter.checkTime ?? Date())
                let title = filter.titleLocation ?? ""
                
                cell.initData(title: "\(checkString) - \(title) - \(formattedTime)", desc: filter.descLocation ?? "", img: filter.image ?? "image_not_available")
                return cell
            }
           
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
