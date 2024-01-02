//
//  DetailCell.swift
//  Attendance
//
//  Created by Phincon on 29/11/23.
//

import UIKit

class DetailCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    
    func initData(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
}
