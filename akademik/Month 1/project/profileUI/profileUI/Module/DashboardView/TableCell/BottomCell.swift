//
//  BottomCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit

protocol BottomCellDelegate {
    func didButtonTapped()
}

class BottomCell: UITableViewCell {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var manyItemLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    var delegate: BottomCellDelegate?
    
    var totalPrice: Float = 0 {
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
    }
    
    @objc func buttonViewTapped() {
        delegate?.didButtonTapped()
    }

    
    func setup() {
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonViewTapped))
        buttonView.addGestureRecognizer(tapGesture)
    }
    
    func loadData() {        
    }
    
    
}
