//
//  ChartCell.swift
//  profileUI
//
//  Created by Phincon on 07/11/23.
//

import UIKit

protocol CartCellDelegate {
    func didMinusTapped(_ item: ItemModel)
    func didPlusTapped(_ item:  ItemModel)
    func didTashTapped(_ item:  ItemModel)
}


class CartCell: UITableViewCell {
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageeView: UIImageView!
    
    var delegate: CartCellDelegate?
    var item: ItemModel? {
        didSet {
            loadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func minusTapped() {
        if var item = item {
            delegate?.didMinusTapped(item)
        }
    }

    @objc func plusTapped() {
        if var item = item {
            delegate?.didPlusTapped(item)
        }
    }
    
    @objc func trashTapped() {
        if var item = item {
            delegate?.didTashTapped(item)
        }
    }


    
    func setup() {
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(trashTapped), for: .touchUpInside)
    }
    
    func loadData() {
        namaLabel.text = item?.name ?? ""
        qtyLabel.text = "\(item?.quantity ?? 0)"
        priceLabel.text = item?.price?.toDollarFormat()
        let image = item?.image ?? "image_not_available"
        imageeView.image = UIImage(named: image)
    }
    
}
