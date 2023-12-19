//
//  BalanceCell.swift
//  Fintech
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class BalanceCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        cardView.roundCorners(corners: .allCorners, cornerRadius: 20)
    }
}
