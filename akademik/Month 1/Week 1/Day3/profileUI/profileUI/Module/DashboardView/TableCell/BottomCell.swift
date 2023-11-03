//
//  BottomCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit

class BottomCell: UITableViewCell {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var manyItemLabel: UILabel!
    
    var totalPrice = 0 {
        didSet {
            totalPriceLabel.text = totalPrice.toDollarFormat()
        }
    }
    
    var manyItem = 0 {
        didSet {
            manyItemLabel.text = "\(manyItem) Items"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
        loadData()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup() {
        selectionStyle = .none
    }
    
    func loadData() {        
    }
    
    
}
