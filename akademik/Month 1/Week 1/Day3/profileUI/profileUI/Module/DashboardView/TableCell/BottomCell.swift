//
//  BottomCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit

class BottomCell: UITableViewCell {
    @IBOutlet weak var barView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {

    }
    
}
