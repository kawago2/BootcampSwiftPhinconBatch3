import UIKit
import RxSwift
import RxGesture
import FirebaseFirestore
import SnapKit

// MARK: - Enum

enum FilterType {
    case day, week, month, year

    var calendarComponent: Calendar.Component {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        case .year: return .year
        }
    }
}

class HistoryViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var loadingView: CustomLoading!
    @IBOutlet weak var emptyView: CustomEmpty!
    
    // MARK: - Properties
    
    private var viewModel: HistoryViewModel!
    private var dataSource: UITableViewDiffableDataSource<Int, InfoItem>!
    private var snapshot = NSDiffableDataSourceSnapshot<Int, InfoItem>()
    private let scrollToTopButton = UIButton(type: .system)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupDataSource()
        setupEvent()
        setupScrollToTopButton()
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonTapped(filterType: .day)
    }
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = HistoryViewModel()
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.05)
        bottomView.makeCornerRadius(20)
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
    }
    
    // MARK: - Setup Event
    
    func setupEvent() {
        viewModel.showAlert.subscribe(onNext: {[weak self] (title, mes) in
            guard let self = self else {return}
            self.showAlert(title: title, message: mes)
        }).disposed(by: disposeBag)
        
        viewModel.emptyViewHidden.subscribe(onNext: {[weak self] result in
            guard let self = self else { return }
            if result {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
            }
        }).disposed(by: disposeBag)
        
        dayButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.buttonTapped(filterType: .day)
        }).disposed(by: disposeBag)
        
        weekButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.buttonTapped(filterType: .week)
        }).disposed(by: disposeBag)
        
        monthButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.buttonTapped(filterType: .month)
        }).disposed(by: disposeBag)
        
        yearButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.buttonTapped(filterType: .year)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Button Configure
    
    private func buttonTapped(filterType: FilterType) {
        self.fetchData {
            self.viewModel.filterData(by: filterType.calendarComponent)
            self.loadSnapshot()
        }
        
       
       
        dayButton.isSelected = filterType == .day
        weekButton.isSelected = filterType == .week
        monthButton.isSelected = filterType == .month
        yearButton.isSelected = filterType == .year
    }
    
    // MARK: - Setup Button Scroll to Top
    
    private func setupScrollToTopButton() {
        scrollToTopButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        scrollToTopButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.goToTopButtonTapped()
        }).disposed(by: disposeBag)
        
        scrollToTopButton.translatesAutoresizingMaskIntoConstraints = false
        scrollToTopButton.isHidden = true
        view.addSubview(scrollToTopButton)

        scrollToTopButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-100)
        }
        
    }
    
     private func goToTopButtonTapped() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // MARK: - Fetch Data
    
    private func fetchData(completion: @escaping (() -> Void)) {
        showLoading()
        viewModel.getData { result in
            switch result {
            case .success:
                self.hideLoading()
                completion()
            case .failure(let error):
                self.hideLoading()
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Setup Diffable Data Source

extension HistoryViewController {
    private func setupDataSource() {
        dataSource = .init(tableView: tableView) { [weak self] (tableView, indexPath, itemIdentifier) in
            guard let _ = self else { return UITableViewCell() }
            let cell: LocationCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.initData(item: itemIdentifier)
            return cell
        }
        
        dataSource.defaultRowAnimation = .automatic
    }
    
    private func loadSnapshot() {
        var newSnapshot = NSDiffableDataSourceSnapshot<Int, InfoItem>()
        newSnapshot.appendSections([0])
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        if viewModel.filteredData.isEmpty == false {
            for data in viewModel.filteredData {
                let checkString = data.isCheck ?? false ? "Check In" : "Check Out"
                let formattedTime = timeFormatter.string(from: data.checkTime ?? Date())
                let title = data.titleLocation ?? ""
                
                let identifier = "\(checkString) - \(title) - \(formattedTime)"
                let item = InfoItem(
                    title: identifier,
                    description: data.descLocation ?? "",
                    imageName: data.image ?? "image_not_available"
                )
                
                newSnapshot.appendItems([item], toSection: 0)
            }
            
        }
        dataSource.apply(newSnapshot, animatingDifferences: true)
    }



}

// MARK: - Configure Table View

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offset >= contentHeight - screenHeight {
            scrollToTopButton.isHidden = false
        } else {
            scrollToTopButton.isHidden = true
        }
    }
}
