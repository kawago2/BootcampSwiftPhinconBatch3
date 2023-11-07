//
//  ChartCell.swift
//  profileUI
//
//  Created by Phincon on 07/11/23.
//

import UIKit

class ChartCell: UITableViewCell {
    @IBOutlet weak var namaLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        
    }
    
    func configureData(name: String){
        namaLabel.text = name
        
    }
    
}
