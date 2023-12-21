//
//  TableCell.swift
//  Attendance
//
//  Created by Phincon on 30/11/23.
//

import UIKit

class TableCell: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!

    
    var allowances: [Allowance] = []
    var deductions: [Deduction] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func setupUI() {
        selectionStyle = .none
        tableView.registerCellWithNib(DetailCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension TableCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0 :
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
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
            let item = allowances[row]
            cell.initData(key: item.name, value: "+ " + item.amount.formatAsRupiah())
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
            let item = deductions[row]
            cell.initData(key: item.name, value:  "- " + item.amount.formatAsRupiah())
            return cell
        default:
            return UITableViewCell()
            
        }
        

    }
}
