//
//  FoodCell.swift
//  profileUI
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class FoodCell: UITableViewCell {
    @IBOutlet weak var namaMakananLabel: UILabel!
    @IBOutlet weak var hargaMakananLabel: UILabel!
    
    @IBOutlet weak var imgMakanan: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup() {
        containerView.setRadius()
        imgMakanan.setRoundedBorder()
    }
}
