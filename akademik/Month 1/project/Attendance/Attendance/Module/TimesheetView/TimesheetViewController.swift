import UIKit
import RxSwift
import FirebaseFirestore

class TimesheetViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: CustomLoading!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var emptyView: CustomEmpty!
    
    
    var timesheetData: [TimesheetItem] = []
    var completedTimesheets: [TimesheetItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var cellContexts: [String] = ["date", "option"]
    let disposeBag = DisposeBag()
    var currentSortBy = ""
    
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
        addButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.navigateFP()
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        tableView.registerCellWithNib(TimesheetCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        collectionView.registerCellWithNib(SortbyCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        let status = NetworkStatus.getStatus()
        switch status {
        case .connected:
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
                            let statusString = data["status"] as? String
                            let status = TaskStatus(rawValue: statusString ?? "")
                            let timesheetItem = TimesheetItem(id:id, startDate: startDate?.dateValue(), endDate: endDate?.dateValue(), position: position, task: task, status: status)
                            self.timesheetData.append(timesheetItem)
                        }
                    }
                    self.didLabelTapped(sortby: self.currentSortBy)
                    self.updateEmptyView()
                    completion()
                case .failure(let error):
                    print("Error getting data from subcollection: \(error.localizedDescription)")
                }
            }
        case .notConnected:
            print("fetch tidak di execute")
        }
    }
    
    func updateEmptyView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.completedTimesheets.isEmpty {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
                
            }
        }
    }
}


extension TimesheetViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTimesheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimesheetCell", for: indexPath) as! TimesheetCell
        
        let timesheet = completedTimesheets[index]
        let startDate = timesheet.startDate
        let endDate = timesheet.endDate
        let position = timesheet.position
        let task = timesheet.task
        let status = timesheet.status
        
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
        
        cell.initData(date: formattedStartDate, clock: clockString, position: position ?? "", task: task ?? "", status: status ?? .inProgress)
        
        return cell
        
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
        let deletedDocumentID = completedTimesheets[index].id ?? ""
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
        
        let timesheetItem = completedTimesheets[index]
        
        let vc = AddFormViewController()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.context = "edit"
        vc.documentID = timesheetItem.id ?? ""
        vc.initData(startDate: timesheetItem.startDate ?? Date(), endDate: timesheetItem.endDate ?? Date(), position: timesheetItem.position ?? "" , task: timesheetItem.task ?? "" , status:  timesheetItem.status ?? .inProgress)
        present(vc, animated: true)
    }
    
}


extension TimesheetViewController: AddFormViewControllerDelegate {
    func didAddTapped(item: TimesheetItem) {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "timesheets"
        let dataToAdd: [String:Any] = [
            "start_date": item.startDate ?? Date(),
            "end_date": item.endDate ?? Date(),
            "position": item.position ?? "",
            "task": item.task ?? "",
            "status": item.status?.rawValue ?? ""
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
    
    func didEditTapped(item: TimesheetItem) {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        let collection = "users"
        let subcollectionPath = "timesheets"
        let editedDocumentID = item.id ?? ""
        
        let dataToEdit: [String:Any] = [
            "start_date": item.startDate ?? Date(),
            "end_date": item.endDate ?? Date(),
            "position": item.position ?? "",
            "task": item.task ?? "",
            "status": item.status?.rawValue ?? ""
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
        
}


extension TimesheetViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        switch index {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortbyCell", for: indexPath) as! SortbyCell
            cell.delegate = self
            cell.context = "date"
            cell.initData(title: "Date")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortbyCell", for: indexPath) as! SortbyCell
            cell.delegate = self
            cell.context = "option"
            cell.initData(title: "Status")
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}


extension TimesheetViewController : SortbyCellDelegate {
    func didLabelTapped(sortby: String) {
        self.currentSortBy = sortby
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.sortByStatus(sortby: sortby)
            self.sortByDate(sortby: sortby)
            self.updateEmptyView()
            self.tableView.reloadData()
        })
    }

    func sortByStatus(sortby: String) {
        switch sortby {
        case TaskStatus.completed.rawValue.lowercased():
            completedTimesheets = timesheetData.filter { $0.status == .completed }
        case TaskStatus.inProgress.rawValue.lowercased():
            completedTimesheets = timesheetData.filter { $0.status == .inProgress }
        case TaskStatus.rejected.rawValue.lowercased():
            completedTimesheets = timesheetData.filter { $0.status == .rejected }
        default:
            completedTimesheets = timesheetData
        }
    }
    
    func sortByDate(sortby: String) {
        print(sortby)
        switch sortby {
            
        case DateSortOption.oldest.rawValue.lowercased():
            completedTimesheets = completedTimesheets.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
        case DateSortOption.newest.rawValue.lowercased():
            completedTimesheets = completedTimesheets.sorted { $0.startDate ?? Date() > $1.startDate ?? Date() }
        default:
            break
        }
    }

}
