import UIKit
import RxSwift
import RxCocoa
import RxGesture
import FloatingPanel

class PermissionViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var emptyView: CustomEmpty!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var addButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    
    // MARK: - Properties
    
    private var fpc: FloatingPanelController!
    private var viewModel: PermissionViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupEvent()
        setupFP()
        configureTable()
        configureCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup ViewModel
    
    private func setupViewModel() {
        viewModel = PermissionViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        cardView.makeCornerRadius(20)
        circleView.tintColor = .white.withAlphaComponent(0.05)
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        viewModel.showAlert.subscribe(onNext: {[weak self] (title, mes) in
            guard let self = self else { return }
            self.showAlert(title: title, message: mes)
        }).disposed(by: disposeBag)
        
        backButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.popView()
        }).disposed(by: disposeBag)
        
        addButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigateFP()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    private func navigateFP() {
        let vc = AddPermissionViewController()
        vc.delegate = self
        fpc.set(contentViewController: vc)
        present(fpc, animated: true, completion: nil)
    }
    
    // MARK: - Update Empty View
    
    private func updateEmptyView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.viewModel.filterPermission.isEmpty {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
            }
        }
    }
    
    // MARK: - Fetch Data
    
    private func fetchData() {
        viewModel.getData {result in
            switch result {
            case .success():
                self.tableView.reloadData()
                self.didLabelTapped(sortby: self.viewModel.currentSortBy)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Configure Table

extension PermissionViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTable() {
        tableView.registerCellWithNib(PermissionCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterPermission.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionCell", for: indexPath) as? PermissionCell {
            cell.initData(permission: viewModel.filterPermission[index])
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
        viewModel.deleteData(at: index) {result in
            switch result {
            case .success():
                self.fetchData()
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
    }
}

// MARK: - Configure Collection

extension PermissionViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - Setup Delegate

extension PermissionViewController : SortbyCellDelegate {
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

extension PermissionViewController: AddPermissionDelegate {
    func didAddTap(item: PermissionAdd) {
        viewModel.addData(item: item) {result in
            switch result {
            case .success():
                self.dismiss(animated: true) {
                    self.showAlert(title: "Success", message: "Form successly created\nPlease wait Approval.")
                }
            case .failure(let error):
                self.dismiss(animated: true) {
                    self.showAlert(title: "Failed", message: error.localizedDescription)
                }
            }
            
        }
    }
}

// MARK: - Setup Floating Panel

extension PermissionViewController :FloatingPanelControllerDelegate {
    private func setupFP() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.surfaceView.appearance.cornerRadius = 20
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.surfaceView.isUserInteractionEnabled = true
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.surfaceView.gestureRecognizers = nil
        fpc.isRemovalInteractionEnabled = false
    }
    
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

