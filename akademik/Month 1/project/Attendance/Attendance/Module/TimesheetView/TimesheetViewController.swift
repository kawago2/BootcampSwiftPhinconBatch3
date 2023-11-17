import UIKit
import FirebaseFirestore

class TimesheetViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: CustomLoading!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var emptyView: UIView!
    
    
    var timesheetData: [TimesheetItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData(completion: {
            self.loadingView.stopAnimating()
            self.tableView.reloadData()
        })
        
    }
    func buttonEvent() {
        addButton.addTarget(self, action: #selector(navigateFP), for: .touchUpInside)
    }
    
    func setupUI() {
        emptyView.isHidden = true
        
        
        tableView.registerCellWithNib(TimesheetCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    @objc func navigateFP() {
        let contentVC = AddFormViewController()
        contentVC.context = "add"
        contentVC.delegate = self
        let navController = UINavigationController(rootViewController: contentVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)

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
                    let id = document.documentID
                    if let data = document.data() {
                        let startDate = data["start_date"] as? Timestamp
                        let endDate = data["end_date"] as? Timestamp
                        let position = data["position"] as? String
                        let task = data["task"] as? String
                        let status = data["status"] as? Int
                        
                        let timesheetItem = TimesheetItem(id:id, startDate: startDate?.dateValue(), endDate: endDate?.dateValue(), position: position, task: task, status: status)
                        self.timesheetData.append(timesheetItem)
                    }
                }
                completion()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if self.timesheetData.isEmpty {self.emptyView.isHidden = false} else {self.emptyView.isHidden = true}
                    
                }
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
        let status = timesheet.status ?? 4
        
        var formattedStartDate = ""
        if let startDate = startDate {
            formattedStartDate = startDate.formattedShortDateString()
        }
        
        var formattedStartTime = ""
        if let startDate = startDate {
            formattedStartTime = startDate.formattedShortTimeString()
        }
        
        var formattedEndTime = ""
        if let endDate = endDate {
            formattedEndTime = endDate.formattedShortTimeString()
        }
        
        let clockString = "•\(formattedStartTime) - \(formattedEndTime)"
        
        cell.initData(date: formattedStartDate, clock: clockString, position: position ?? "", task: task ?? "", status: status)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.item
        if editingStyle == .delete {
            deleteRow(at: index)
        }
    }
    
    private func deleteRow(at index: Int) {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "timesheets"
        let deletedDocumentID = timesheetData[index].id ?? ""
        FFirestore.deleteDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath, documentIDToDelete: deletedDocumentID) { result in
            switch result {
            case .success:
                print("Data deleted from subcollection successfully")
            case .failure(let error):
                print("Error deleting data from subcollection: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        fetchData(completion: {
            self.loadingView.stopAnimating()
            self.tableView.reloadData()
           
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let timesheetItem = timesheetData[index]
        
        let vc = AddFormViewController()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.context = "edit"
        vc.documentID = timesheetItem.id ?? ""
        vc.initData(startDate: timesheetItem.startDate ?? Date(), endDate: timesheetItem.endDate ?? Date(), position: timesheetItem.position ?? "" , task: timesheetItem.task ?? "" , status:  timesheetItem.status ?? 4)
        present(vc, animated: true)
    }
    
}


extension TimesheetViewController: AddFormViewControllerDelegate {
    func didEditTapped(startDate: Date, endDate: Date, position: String, task: String, status: Int,id : String) {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        let collection = "users"
        let subcollectionPath = "timesheets"
        let editedDocumentID = id
        
        let dataToEdit: [String:Any] = [
            "start_date": startDate,
            "end_date": endDate,
            "position": position,
            "task": task,
            "status": status
        ]
        
        FFirestore.editDataInSubcollection(documentID: uid, inCollection: collection, subcollectionPath: subcollectionPath, documentIDToEdit: editedDocumentID, newData: dataToEdit) { result in
            switch result {
            case .success:
                print("Document updated successfully")
            case .failure(let error):
                print("Error updating document: \(error)")
            }
        }
        fetchData(completion: {
            self.loadingView.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    func didAddTapped(startDate: Date, endDate: Date, position: String, task: String, status: Int) {
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
            "task": task,
            "status": status
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
            self.loadingView.stopAnimating()
            self.tableView.reloadData()
        })
    }
}
