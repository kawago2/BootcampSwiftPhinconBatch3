import UIKit
import FirebaseFirestore
import FloatingPanel

class TimesheetViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: CustomLoading!
    @IBOutlet weak var addButton: UIButton!
    
    var timesheetData: [TimesheetItem] = []
    var floatingPanelController: FloatingPanelController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData(completion: {
            self.tableView.reloadData()
            self.loadingView.stopAnimating()
        })
    }
    func buttonEvent() {
        addButton.addTarget(self, action: #selector(navigateFP), for: .touchUpInside)
    }
    
    func setupUI() {
        tableView.registerCellWithNib(TimesheetCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    @objc func navigateFP() {
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.panGestureRecognizer.isEnabled = true
        floatingPanelController.surfaceView.grabberHandle.isHidden = true
        
        // Initialize your custom layout
        let customLayout = CustomFloatingPanelLayout()
        floatingPanelController.layout = customLayout
        
        let contentVC = AddFormViewController()
        contentVC.delegate = self
        floatingPanelController.set(contentViewController: contentVC)
        
        present(floatingPanelController, animated: true, completion: nil)
    }

    func fetchData(completion: @escaping () -> Void?) {
        loadingView.startAnimating()
        timesheetData = []
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "timesheets"
        
        FFirestore.getDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath) { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    if let data = document.data() {
                        let startDate = data["start_date"] as? Timestamp
                        let endDate = data["end_date"] as? Timestamp
                        let position = data["position"] as? String
                        let task = data["task"] as? String
                        
                        let timesheetItem = TimesheetItem(startDate: startDate?.dateValue(), endDate: endDate?.dateValue(), position: position, task: task)
                        self.timesheetData.append(timesheetItem)
                    }
                }
                completion()
            case .failure(let error):
                print("Error getting data from subcollection: \(error.localizedDescription)")
            }
        }
    }
}


extension TimesheetViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesheetData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimesheetCell", for: indexPath) as! TimesheetCell
        
        let timesheet = timesheetData[index]
        let startDate = timesheet.startDate
        let endDate = timesheet.endDate
        let position = timesheet.position
        let task = timesheet.task

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        var formattedStartDate = ""
        if let startDate = startDate {
            formattedStartDate = dateFormatter.string(from: startDate)
        }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        var formattedStartTime = ""
        if let startDate = startDate {
            formattedStartTime = timeFormatter.string(from: startDate)
        }

        var formattedEndTime = ""
        if let endDate = endDate {
            formattedEndTime = timeFormatter.string(from: endDate)
        }

        let clockString = "\(formattedStartTime)\n - \n\(formattedEndTime)"

        cell.initData(date: formattedStartDate, clock: clockString, position: position ?? "", task: task ?? "")

        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

extension TimesheetViewController : FloatingPanelControllerDelegate {
    // MARK: - FloatingPanelControllerDelegate

    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingPanelLayout()
    }
}

class CustomFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanel.FloatingPanelPosition {
        return .bottom
    }
    
    var initialState: FloatingPanel.FloatingPanelState {
        return .half
    }
    
    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 264.0, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea)
            // Adjust as needed
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.30
    }
}


extension TimesheetViewController: AddFormViewControllerDelegate {
    func didAddTapped(startDate: Date, endDate: Date, position: String, task: String) {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "timesheets"
        let dataToAdd: [String:Any] = [
            "start_date": startDate,
            "end_date": endDate,
            "position": position,
            "task": task
        ]

        FFirestore.addDataToSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath, data: dataToAdd) { result in
            switch result {
            case .success:
                print("Data added to subcollection successfully")
                self.dismiss(animated: true)
            case .failure(let error):
                print("Error adding data to subcollection: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        fetchData(completion: {
            self.tableView.reloadData()
        })
    }
}
