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
        dataSet.valueFont = UIFont(name: "Avenir", size: 10) ?? UIFont.systemFont(ofSize: 10)
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.sliceSpace = 2
        let data = PieChartData(dataSet: dataSet)

        pieChartView.data = data
        pieChartView.setNeedsDisplay()
        pieChartView.drawCenterTextEnabled = true
        pieChartView.centerText = "Gross Pay\n\(totalAll.formatAsRupiah())"
        
        
        // Menambahkan nilai di legenda
        let legend = pieChartView.legend
        legend.enabled = true
        legend.form = .circle
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        
        let basicLegend = LegendEntry(label: "Basic Salary")
        basicLegend.form = Legend.Form.circle
        basicLegend.formSize = 10
        basicLegend.formLineWidth = 10
        basicLegend.formLineDashPhase = 0
        basicLegend.formLineDashLengths = nil
        basicLegend.formColor = dataSet.color(atIndex: 0)

        let allowancesLegend = LegendEntry(label: "Allowances (\(totalAllowances.formatAsRupiah()))")
        allowancesLegend.form = Legend.Form.circle
        allowancesLegend.formSize = 10
        allowancesLegend.formLineWidth = 10
        allowancesLegend.formLineDashPhase = 0
        allowancesLegend.formLineDashLengths = nil
        allowancesLegend.formColor = dataSet.color(atIndex: 1)

        let deductionsLegend = LegendEntry(label: "Deductions (\(totalDeductions.formatAsRupiah()))")
        deductionsLegend.form = Legend.Form.circle
        deductionsLegend.formSize = 10
        deductionsLegend.formLineWidth = 10
        deductionsLegend.formLineDashPhase = 0
        deductionsLegend.formLineDashLengths = nil
        deductionsLegend.formColor = dataSet.color(atIndex: 2)

        let legendEntries = [basicLegend, allowancesLegend, deductionsLegend]


        legend.setCustom(entries: legendEntries)

        
        pieChartView.entryLabelFont = UIFont(name: "Avenir", size: 10) ?? UIFont.systemFont(ofSize: 10)
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.highlightPerTapEnabled = false

        pieChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
}
