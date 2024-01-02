import UIKit
import RxGesture
import RxSwift
import DGCharts

class DetailPayrollViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var circleVIew: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    
    // MARK: - Properties
    
    private var payrollItem =  Payroll()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        configureTable()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        cardView.makeCornerRadius(20)
        circleVIew.tintColor = .white.withAlphaComponent(0.05)
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        backButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.popView()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Setup Cell
    
    internal func initData(item: Payroll) {
        self.payrollItem = item
    }    
}

// MARK: - Setup Table View

extension DetailPayrollViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTable() {
        tableView.registerCellWithNib(TableCell.self)
        tableView.registerCellWithNib(ChartCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChartCell
            
            cell.setupPieChart(allowances: payrollItem.allowances ?? [], deductions: payrollItem.deductions ?? [], item: payrollItem)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableCell
            cell.allowances = self.payrollItem.allowances ?? []
            cell.deductions = self.payrollItem.deductions ?? []
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Earning Details"
        default:
            return nil
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 313
        case 1:
            if let allowances = payrollItem.allowances, let deductions = payrollItem.deductions {
                let numberOfRows = allowances.count + deductions.count
                let estimatedHeightForRow = 33.0
                let diff = allowances.isEmpty || deductions.isEmpty ? 0: 50.0
                return (CGFloat(numberOfRows) * estimatedHeightForRow) + diff
            }
            else {
                return 0
            }
        default:
            return 0
        }
    }
}
