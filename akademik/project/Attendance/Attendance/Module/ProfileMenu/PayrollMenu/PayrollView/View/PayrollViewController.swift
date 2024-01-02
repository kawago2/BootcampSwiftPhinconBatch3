import UIKit
import RxSwift
import RxGesture
import FirebaseFirestore

class PayrollViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var viewModel: PayrollViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        configureTable()
        configureCollection()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = PayrollViewModel()
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
    }
    
    // MARK: - Fetch Data
    
    private func fetchData() {
        viewModel.getData(completionHandler: {result in
            switch result {
            case .success():
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        })
    }
}

// MARK: - Configure Table View

extension PayrollViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(PayrollCell.self)
        tableView.allowsMultipleSelection = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filtereddataPayroll.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayrollCell", for: indexPath) as? PayrollCell
        guard let cell = cell else { return  UITableViewCell() }
        let item = viewModel.filtereddataPayroll[index]
        
        
        cell.initData(date: item.date?.formattedShortDateString() ?? "", pay: item.netSalary?.formatAsRupiah() ?? "", month: item.date?.getMonth() ?? "")
        
        switch index {
        case 0:
            cell.configuration(first: true, last: false)
        case viewModel.filtereddataPayroll.count - 1:
            cell.configuration(first: false, last: true)
        default:
            cell.configuration(first: false, last: false)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = DetailPayrollViewController()
        vc.initData(item: viewModel.filtereddataPayroll[index])
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Configure Collection

extension PayrollViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollection() {
        collectionView.registerCellWithNib(SortbyCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
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


extension PayrollViewController : SortbyCellDelegate {
    func didLabelTapped(sortby: String) {
        self.viewModel.currentSortBy = sortby
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            self.viewModel.filtereddataPayroll = self.viewModel.dataPayroll
            self.sortByDate(sortby: sortby)
            self.tableView.reloadData()
        })
    }
    
    func sortByDate(sortby: String) {
        switch sortby {
        case DateSortOption.oldest.rawValue.lowercased():
            viewModel.filtereddataPayroll = viewModel.filtereddataPayroll.sorted { $0.date ?? Date()  < $1.date ?? Date() }
        case DateSortOption.newest.rawValue.lowercased():
            viewModel.filtereddataPayroll = viewModel.filtereddataPayroll.sorted { $0.date ?? Date() > $1.date ?? Date() }
        default:
            break
        }
    }
    
}
