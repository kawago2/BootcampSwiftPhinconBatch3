import UIKit
import RxSwift
import RxCocoa
import FloatingPanel
import FirebaseAuth

class PermissionViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    var fpc: FloatingPanelController!
    let disposeBag = DisposeBag()
    
    var permissionData: [PermissionForm] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEvent()
        setupFP()
        getData()
        setupUI()
    }
    
    func buttonEvent() {
        backButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backTo()
        }).disposed(by: disposeBag)
        
        addButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.navigateFP()
            
        }).disposed(by: disposeBag)
        
    }
    
    func backTo(){
        navigationController?.popViewController(animated: true)
    }
    
    func setupFP() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.surfaceView.appearance.cornerRadius = 20
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.surfaceView.isUserInteractionEnabled = true
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.isRemovalInteractionEnabled = false
    }
    
    func navigateFP() {
        let vc = AddPermissionViewController()
        fpc.set(contentViewController: vc)
        present(fpc, animated: true, completion: nil)
    }
    
    func setupUI() {
        tableView.registerCellWithNib(PermissionCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func getData() {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("Error: Current user ID is nil")
            return
        }
        
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
}

extension PermissionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissionData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionCell", for: indexPath) as? PermissionCell {
            cell.initData(permission: permissionData[index])
            return cell
        }
        return UITableViewCell()
    }
}



extension PermissionViewController :FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return AddPermissionFloatingPanel()
    }
    
}


class AddPermissionFloatingPanel: FloatingPanelLayout {
    var position: FloatingPanel.FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanel.FloatingPanelState = .half
    
    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring] = [
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.20
    }
    
    
    
}
