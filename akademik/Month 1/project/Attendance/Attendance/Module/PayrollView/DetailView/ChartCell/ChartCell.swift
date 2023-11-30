import UIKit
import DGCharts

class ChartCell: UITableViewCell {
    
    @IBOutlet weak var pieChartView: PieChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupPieChart(allowances: [Allowance], deductions: [Deduction], item: Payroll) {
        let totalAllowances = allowances.reduce(0) { $0 + $1.amount }
        let totalDeductions = deductions.reduce(0) { $0 + $1.amount }
        let entries: [ChartDataEntry] = [
            PieChartDataEntry(value: Double(item.basicSalary), label: "Basic Salary"),
            PieChartDataEntry(value: Double(totalAllowances), label: "Allowances"),
            PieChartDataEntry(value: Double(totalDeductions), label: "Deductions"),
        ]
        
        let totalAll = totalAllowances + totalDeductions + (item.basicSalary)
        
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
    
}
