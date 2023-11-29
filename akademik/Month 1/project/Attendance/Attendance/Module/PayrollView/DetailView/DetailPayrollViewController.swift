import UIKit
import RxGesture
import RxSwift
import DGCharts

class DetailPayrollViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var circleVIew: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var heightofTableView: NSLayoutConstraint!
    
    private var payrollItem: Payroll?
    
    let disposeBag = DisposeBag()
    
    var allowances: [Allowance] = []
    var deductions: [Deduction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        if let _ = payrollItem {
            setupPieChart()
        }
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
        
        tableView.registerCellWithNib(DetailCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupPieChart() {
        let totalAllowances = allowances.reduce(0) { $0 + $1.amount }
        let totalDeductions = deductions.reduce(0) { $0 + $1.amount }
        let entries: [ChartDataEntry] = [
            PieChartDataEntry(value: Double(payrollItem?.basicSalary ?? 0.0), label: "Basic Salary"),
            PieChartDataEntry(value: Double(totalAllowances), label: "Allowances"),
            PieChartDataEntry(value: Double(totalDeductions), label: "Deductions"),
        ]
        
        let totalAll = totalAllowances + totalDeductions + (payrollItem?.basicSalary ?? 0)
        
        let dataSet = PieChartDataSet(entries: entries, label: "Salary Breakdown")
        dataSet.drawValuesEnabled = false
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.sliceSpace = 2
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
        pieChartView.drawCenterTextEnabled = true
        pieChartView.centerText = "Gross Pay\n\(totalAll.formatAsRupiah())"
        
        
        pieChartView.legend.enabled = true
        pieChartView.legend.form = .circle
        pieChartView.legend.horizontalAlignment = .center
        pieChartView.legend.verticalAlignment = .bottom
        pieChartView.legend.orientation = .horizontal
        
        
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.highlightPerTapEnabled = false

        pieChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
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
        print(allowances.count)
        print(deductions.count)
        switch section {
        case 0:
            return allowances.count
        case 1:
            return deductions.count
        default:
            return 0
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        let section = indexPath.section
        switch section {
        case 0:
            let index = indexPath.row
            let item = allowances[index]
            cell.initData(key: item.name, value: item.amount.formatAsRupiah())
        case 1:
            let index = indexPath.row
            let item = deductions[index]
            cell.initData(key: item.name, value: item.amount.formatAsRupiah())
        heightofTableView.constant = tableView.contentSize.height

        default:
            return UITableViewCell()
        }
        return cell
    }
    
    
}
