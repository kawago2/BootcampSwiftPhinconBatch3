//
//  DetailCell.swift
//  Attendance
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        selectionStyle = .none
    }
    
    func initData(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
}
