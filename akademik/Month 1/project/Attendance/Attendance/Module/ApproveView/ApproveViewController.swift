import UIKit
import RxCocoa
import RxSwift
class ApproveViewController: UIViewController {
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var emptyView: CustomEmpty!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    
    
    let disposeBag = DisposeBag()
    var permissionData: [PermissionForm] = []
    var completedPermission: [PermissionForm] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var currentSortBy = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        buttonEvent()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func buttonEvent() {
        backButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.backToView()
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        circleView.tintColor = .white.withAlphaComponent(0.05)
        
        tableView.registerCellWithNib(ApproveCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        collectionView.registerCellWithNib(SortbyCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func backToView() {
        navigationController?.popViewController(animated: true)
    }
    
    func getData() {
        permissionData = []
        let collectionGroupPath = "data"
        
        FFirestore.getAllDocumentsFromSubcollection(collectionGroupPath: collectionGroupPath) { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    let data = document.data()
                    var permissionForm = PermissionForm()
                    permissionForm.fromDictionary(dictionary: data)
                    self.permissionData.append(permissionForm)
                }
                self.didLabelTapped(sortby: self.currentSortBy)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func updateEmptyView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.completedPermission.isEmpty {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
            }
        }
    }
}



extension ApproveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedPermission.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rejectAction = UIContextualAction(style: .normal, title: "Reject") { (_, _, completion) in
            self.rejectAction(forRowAt: indexPath)
            completion(true)
        }
        rejectAction.backgroundColor = UIColor.systemRed

        return UISwipeActionsConfiguration(actions: [rejectAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let approveAction = UIContextualAction(style: .normal, title: "Approve") { (_, _, completion) in
            self.approveAction(forRowAt: indexPath)
            completion(true)
        }
        approveAction.backgroundColor = UIColor.systemGreen

        return UISwipeActionsConfiguration(actions: [approveAction])
    }


    // Custom method to handle the approve action
    private func approveAction(forRowAt indexPath: IndexPath) {
        let permissionItem = completedPermission[indexPath.row]
        let collection = "permissions"
        let subCollection = "data"
        
        let currentDate = Date()
        let dataUpdate: [String: Any] = [
            "approvalTime" : currentDate,
            "status" : PermissionStatus.approved.rawValue
        ]
        
        if let uid = permissionItem.applicantID, let id = permissionItem.autoGeneratedID {
            FFirestore.editDataInSubcollection(documentID: uid, inCollection: collection, subcollectionPath: subCollection, documentIDToEdit: id, newData: dataUpdate) { result in
                switch result {
                case .success:
                    self.showAlert(title: "Approved", message: "Form approve successfuly")
                    self.getData()
                case .failure(let error):
                    print("Error saat mengubah dokumen dalam subkoleksi: \(error.localizedDescription)")
                }
            }
        }
    }

    private func rejectAction(forRowAt indexPath: IndexPath) {
        let permissionItem = completedPermission[indexPath.row]
        let collection = "permissions"
        let subCollection = "data"
        
        let currentDate = Date()
        let dataUpdate: [String: Any] = [
            "approvalTime" : currentDate,
            "status" : PermissionStatus.rejected.rawValue
        ]
        
        if let uid = permissionItem.applicantID, let id = permissionItem.autoGeneratedID {
            FFirestore.editDataInSubcollection(documentID: uid, inCollection: collection, subcollectionPath: subCollection, documentIDToEdit: id, newData: dataUpdate) { result in
                switch result {
                case .success:
                    self.showAlert(title: "Rejected", message: "Form reject successfuly")
                    self.getData()
                case .failure(let error):
                    print("Error saat mengubah dokumen dalam subkoleksi: \(error.localizedDescription)")
                }
            }
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApproveCell", for: indexPath) as? ApproveCell {
            
            let permissionItem = completedPermission[index]
            let collection = "users"
            if let documentID = permissionItem.applicantID {
                FFirestore.getDocument(collection: collection, documentID: documentID) { result in
                    switch result {
                    case .success(let document):
                        if let data = document.data(),
                           let profile = data["profile"] as? [String: Any],
                           let name = profile["name"] as? String {
                            cell.initData(permission: permissionItem, name: name)
                            
                        } else {
                            print("Error: Unable to extract 'name' from document data.")
                        }
                        
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}



extension ApproveViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            cell.initData(title: "Date Permission")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortbyCell", for: indexPath) as! SortbyCell
            cell.delegate = self
            cell.context = "status"
            cell.initData(title: "Status")
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        
        var title = ""
        switch index {
        case 0:
            title = "Date Permission"
        case 1:
            title = "Status"
        default:
            break
        }
        
        let font = UIFont.systemFont(ofSize: 12)
        let titleWidth = NSString(string: title).size(withAttributes: [NSAttributedString.Key.font: font]).width
        
        let cellWidth = titleWidth + 25
        
        return CGSize(width: cellWidth + 100, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension ApproveViewController : SortbyCellDelegate {
    func didLabelTapped(sortby: String) {
        self.currentSortBy = sortby

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.sortByStatus(sortby: sortby)
            self.sortByDate(sortby: sortby)
            self.tableView.reloadData()
            self.updateEmptyView()
        })
    }

    func sortByStatus(sortby: String) {
        switch sortby.lowercased() {
        case PermissionStatus.approved.rawValue.lowercased():
            completedPermission = permissionData.filter { $0.status == .approved }
        case PermissionStatus.rejected.rawValue.lowercased():
            completedPermission = permissionData.filter { $0.status == .rejected }
        case PermissionStatus.submitted.rawValue.lowercased():
            completedPermission = permissionData.filter { $0.status == .submitted }
        default:
            completedPermission = permissionData
        }

    }

    func sortByDate(sortby: String) {
        switch sortby {
        case DateSortOption.oldest.rawValue.lowercased():
            completedPermission = completedPermission.sorted { $0.permissionTime ?? Date() < $1.permissionTime ?? Date() }
        case DateSortOption.newest.rawValue.lowercased():
            completedPermission = completedPermission.sorted { $0.permissionTime ?? Date() > $1.permissionTime ?? Date() }
        default:
            break
        }
    }

}
