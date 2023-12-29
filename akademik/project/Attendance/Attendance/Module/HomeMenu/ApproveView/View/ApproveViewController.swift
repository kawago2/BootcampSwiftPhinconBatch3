import UIKit
import RxCocoa
import RxSwift

class ApproveViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var emptyView: CustomEmpty!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    
    // MARK: - Properties
    
    private var viewModel: ApproveViewModel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupEvent()
        configureTable()
        configureCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup ViewModel
    
    private func setupViewModel() {
        viewModel = ApproveViewModel()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        circleView.tintColor = .white.withAlphaComponent(0.05)
    }
    
    // MARK: - Setup Event
    
    func setupEvent() {
        backButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.popView()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Data Fetching
    
    func fetchData() {
        viewModel.getData(completionHandler: {result in
            switch result {
            case .success():
                self.didLabelTapped(sortby: self.viewModel.currentSortBy)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    // MARK: - Empty View Update
    
    func updateEmptyView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.viewModel.completedPermission.isEmpty {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
            }
        }
    }
}

// MARK: - Configure Table

extension ApproveViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTable() {
        tableView.registerCellWithNib(ApproveCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.completedPermission.count
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

    private func approveAction(forRowAt indexPath: IndexPath) {
        viewModel.approveLogic(forRowAt: indexPath) {result in
            switch result {
            case .success():
                self.showAlert(title: "Approved", message: "Form approve successfuly")
                self.fetchData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func rejectAction(forRowAt indexPath: IndexPath) {
        viewModel.rejectLogic(forRowAt: indexPath) {result in
            switch result {
            case .success():
                self.showAlert(title: "Rejected", message: "Form reject successfuly")
                self.fetchData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApproveCell", for: indexPath) as? ApproveCell {
            
            let permissionItem = viewModel.completedPermission[index]
            let collection = "users"
            if let documentID = permissionItem.applicantID {
                FirebaseManager.shared.getDocument(collection: collection, documentID: documentID) { result in
                    switch result {
                    case .success(let document):
                        if let data = document.data(),
                           let profile = data["profile"] as? [String: Any],
                           let name = profile["name"] as? String {
                            cell.initData(permission: permissionItem, name: name)
                        }
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - Configure Collection

extension ApproveViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollection() {
        collectionView.registerCellWithNib(SortbyCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        switch index {
        case 0:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SortbyCell
            cell.delegate = self
            cell.context = .date
            cell.initData(title: "Date Permission")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SortbyCell
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

// MARK: - Delegate

extension ApproveViewController : SortbyCellDelegate {
    func didLabelTapped(sortby: String) {
        self.viewModel.currentSortBy = sortby
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.viewModel.sortByStatus(sortby: sortby)
            self.viewModel.sortByDate(sortby: sortby)
            self.tableView.reloadData()
            self.updateEmptyView()
        })
    }
}
