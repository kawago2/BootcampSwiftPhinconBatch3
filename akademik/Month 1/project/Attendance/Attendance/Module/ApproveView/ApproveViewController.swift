import UIKit
import RxCocoa
import RxSwift
class ApproveViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var permissionData: [PermissionForm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupUI()
        buttonEvent()
        
    }
    
    func buttonEvent() {
        backButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backToView()
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        tableView.registerCellWithNib(ApproveCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func backToView() {
        navigationController?.popViewController(animated: true)
    }
    
    func getData() {
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}



extension ApproveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(permissionData.count)
        return permissionData.count
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
        let permissionItem = permissionData[indexPath.row]
        
        
        
        
        
        
        print("approve")
    }

    // Custom method to handle the reject action
    private func rejectAction(forRowAt indexPath: IndexPath) {
        let permissionItem = permissionData[indexPath.row]
        print("reject")
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApproveCell", for: indexPath) as? ApproveCell {
            
            let permissionItem = permissionData[index]
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
