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
        buttonEvent()
        setupUI()
        getData()
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
        var listUser: [String] = []
        
        FFirestore.getAllDocuments(collection: "listuser") { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    let data = document.data()
                    if let uid = data["uid"] as? String {
                        print("User UID: \(uid)")
                        listUser.append(uid)
                    } else {
                        print("Error: Unable to retrieve user UID from document data")
                    }
                }
                
                for uid in listUser {
                    let documentID = uid
                    let inCollection = "permissions"
                    let subcollectionPath = "data"

                    FFirestore.getDataFromSubcollection(documentID: documentID, inCollection: inCollection, subcollectionPath: subcollectionPath) { result in
                        switch result {
                        case .success(let documents):
                            for document in documents {
                                if let data = document.data() {
                                    var permissionForm = PermissionForm()
                                    permissionForm.fromDictionary(dictionary: data)
                                    self.permissionData.append(permissionForm)
                                } else {
                                    print("Error: Unable to create PermissionForm from data")
                                }
                            }
                            self.tableView.reloadData()
                        case .failure(let error):
                            print("Error getting data from subcollection: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Error getting documents: \(error.localizedDescription)")
            }
        }
    }
}

extension ApproveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApproveCell", for: indexPath) as? ApproveCell {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
