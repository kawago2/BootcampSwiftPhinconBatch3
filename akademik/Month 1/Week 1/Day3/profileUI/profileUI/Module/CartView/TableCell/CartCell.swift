//
//  ChartCell.swift
//  profileUI
//
//  Created by Phincon on 07/11/23.
//

import UIKit

protocol CartCellDelegate {
    func didMinusTapped()
    func didPlusTapped()
}

class CartCell: UITableViewCell {
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var delegate: CartCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func didMinusTapped() {
        delegate?.didMinusTapped()
    }
    
    @objc func didPlusTapped() {
        delegate?.didPlusTapped()
    }
    
    func setup() {
        minusButton.addTarget(self, action: #selector(didMinusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didPlusTapped), for: .touchUpInside)
    }
    
    func configureData(name: String){
        namaLabel.text = name
        
    }
    
}
