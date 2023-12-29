import UIKit
import RxSwift
import RxGesture
import FirebaseFirestore

// MARK: - Enum

enum Context {
    case add, edit
}

class TimesheetViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: CustomLoading!
    @IBOutlet weak var addButton: UIImageView!
    @IBOutlet weak var emptyView: CustomEmpty!
    @IBOutlet weak var cardView: UIView!
    
    // MARK: - Properties
    
    private var viewModel: TimesheetViewModel!
    
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
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = TimesheetViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        cardView.makeCornerRadius(20)
        circleView.tintColor = .white.withAlphaComponent(0.05)
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        addButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigateFP()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation Pop UP
    
     func navigateFP() {
        let contentVC = AddFormViewController()
        contentVC.context = .add
        contentVC.delegate = self
        let navController = UINavigationController(rootViewController: contentVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)
    }
    
    // MARK: - Fetch Data
    
    func fetchData() {
        self.showLoading()
        viewModel.getData(completionHandler: {result in
            self.hideLoading()
            switch result {
            case .success():
                self.tableView.reloadData()
                self.didLabelTapped(sortby: self.viewModel.currentSortBy)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    // MARK: - Empty View
    
    func updateEmptyView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.viewModel.completedTimesheets.isEmpty {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
                
            }
        }
    }
}

// MARK: - Configure Table View

extension TimesheetViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTable() {
        tableView.registerCellWithNib(TimesheetCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.completedTimesheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimesheetCell", for: indexPath) as! TimesheetCell
        
        let timesheet = viewModel.completedTimesheets[index]
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
        viewModel.deleteData(at: index) { result in
            switch result {
            case .success():
                self.fetchData()
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let timesheetItem = viewModel.completedTimesheets[index]
        
        let vc = AddFormViewController()
        let vm = AddFormViewModel()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.context = .edit
        vm.documentID = timesheetItem.id ?? ""
        vm.startDate.accept(timesheetItem.startDate ?? Date())
        vm.endDate.accept(timesheetItem.endDate ?? Date())
        vm.position.accept(timesheetItem.position ?? "")
        vm.task.accept(timesheetItem.task ?? "")
        vm.status.accept(timesheetItem.status ?? .inProgress)
        vc.viewModel = vm
        present(vc, animated: true)
    }
    
}

// MARK: - Button Add Tapped

extension TimesheetViewController: AddFormViewControllerDelegate {
    func didAddTapped(item: TimesheetItem) {
        viewModel.addData(item: item) {result in
            switch result {
            case .success():
                self.dismiss(animated: true) {
                    self.fetchData()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func didEditTapped(item: TimesheetItem) {
        viewModel.editData(item: item) {result in
            switch result {
            case .success():
                self.fetchData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
    }
}

// MARK: - Configure Collection View

extension TimesheetViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortbyCell", for: indexPath) as! SortbyCell
            cell.delegate = self
            cell.context = .date
            cell.initData(title: "Date")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortbyCell", for: indexPath) as! SortbyCell
            cell.delegate = self
            cell.context = .option
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
            title = "Date"
        case 1:
            title = "Status"
        default:
            break
        }
        
        let font = UIFont.systemFont(ofSize: 12)
        let titleWidth = NSString(string: title).size(withAttributes: [NSAttributedString.Key.font: font]).width
        
        let cellWidth = titleWidth + 10
        
        return CGSize(width: cellWidth + 100, height: 50)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Configure Filter

extension TimesheetViewController : SortbyCellDelegate {
    func didLabelTapped(sortby: String) {
        self.viewModel.currentSortBy = sortby
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.viewModel.sortByStatus(sortby: sortby)
            self.viewModel.sortByDate(sortby: sortby)
            self.updateEmptyView()
            self.tableView.reloadData()
        })
    }
}
