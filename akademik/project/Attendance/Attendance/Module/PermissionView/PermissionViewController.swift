import UIKit
import RxSwift
import RxCocoa
import RxGesture
import FloatingPanel
import FirebaseAuth

class PermissionViewController: UIViewController {
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var emptyView: CustomEmpty!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var addButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    
    
    var fpc: FloatingPanelController!
    let disposeBag = DisposeBag()
    var currentSortBy = ""
    var permissionData: [PermissionForm] = []
    var filterPermission: [PermissionForm] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEvent()
        setupFP()
      
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func buttonEvent() {
        backButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.backTo()
        }).disposed(by: disposeBag)
        
        addButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
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
        fpc.surfaceView.gestureRecognizers = nil
        fpc.isRemovalInteractionEnabled = false
    }
    
    func navigateFP() {
        let vc = AddPermissionViewController()
        vc.delegate = self
        fpc.set(contentViewController: vc)
        present(fpc, animated: true, completion: nil)
    }
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        circleView.tintColor = .white.withAlphaComponent(0.05)
        
        tableView.registerCellWithNib(PermissionCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        collectionView.registerCellWithNib(SortbyCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func updateEmptyView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.filterPermission.isEmpty {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
            }
        }
    }
    
    func getData() {
        permissionData = []
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
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
                    }
                }
                self.tableView.reloadData()
                self.didLabelTapped(sortby: self.currentSortBy)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
}

extension PermissionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPermission.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionCell", for: indexPath) as? PermissionCell {
            cell.initData(permission: filterPermission[index])
            return cell
        }
        return UITableViewCell()
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
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }
        let permissionItem = filterPermission[index]
        if let status = permissionItem.status {
            if status != .submitted {
                self.showAlert(title: "Warning", message: "When form has been validate, cant delete.")
                return
            }
        }
        
        let documentID = uid
        let collection = "permissions"
        let subcollectionPath = "data"
        let deletedDocumentID = permissionItem.autoGeneratedID ?? ""
        FFirestore.deleteDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath, autoGeneratedID: deletedDocumentID) { result in
            switch result {
            case .success:
                print("Data deleted from subcollection successfully")
            case .failure(let error):
                print("Error deleting data from subcollection: \(error.localizedDescription)")
            }
        }
        getData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}


extension PermissionViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        switch index {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortbyCell", for: indexPath) as! SortbyCell
            cell.delegate = self
            cell.context = .date
            cell.initData(title: "Date Permission")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortbyCell", for: indexPath) as! SortbyCell
            cell.delegate = self
            cell.context = .status
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




extension PermissionViewController : SortbyCellDelegate {
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
            filterPermission = permissionData.filter { $0.status == .approved }
        case PermissionStatus.rejected.rawValue.lowercased():
            filterPermission = permissionData.filter { $0.status == .rejected }
        case PermissionStatus.submitted.rawValue.lowercased():
            filterPermission = permissionData.filter { $0.status == .submitted }
        default:
            filterPermission = permissionData
        }
        
    }
    
    func sortByDate(sortby: String) {
        switch sortby {
        case DateSortOption.oldest.rawValue.lowercased():
            filterPermission = filterPermission.sorted { $0.permissionTime ?? Date() < $1.permissionTime ?? Date() }
        case DateSortOption.newest.rawValue.lowercased():
            filterPermission = filterPermission.sorted { $0.permissionTime ?? Date() > $1.permissionTime ?? Date() }
        default:
            break
        }
    }
    
}




extension PermissionViewController: AddPermissionDelegate {
    func didAddTap() {
        getData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

