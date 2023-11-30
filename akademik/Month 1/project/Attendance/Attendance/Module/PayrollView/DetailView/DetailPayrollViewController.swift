import UIKit
import RxGesture
import RxSwift
import DGCharts

class DetailPayrollViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var circleVIew: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
//    @IBOutlet weak var heightofTableView: NSLayoutConstraint!
    
    private var payrollItem: Payroll?
    
    let disposeBag = DisposeBag()
    
    var allowances: [Allowance] = []
    var deductions: [Deduction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    
    func buttonEvent() {
        backButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.backTapped()
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        circleVIew.tintColor = .white.withAlphaComponent(0.05)
        
        tableView.registerCellWithNib(TableCell.self)
        tableView.registerCellWithNib(ChartCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func initData(item: Payroll) {
        self.payrollItem = item
        self.allowances = item.allowances
        self.deductions = item.deductions
    }
    

}

extension DetailPayrollViewController: UITableViewDelegate, UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
            if let payrollItem = payrollItem {
                cell.setupPieChart(allowances: allowances, deductions: deductions, item: payrollItem)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
            cell.allowances = self.allowances
            cell.deductions = self.deductions
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
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}
