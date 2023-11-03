//
//  FoodCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit

class FoodCell: UICollectionViewCell {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var plusButton: UIImageView!
    
    var isFavorited = false
    
    var item: ItemModel? {
        didSet {
            configureCell()
        }
    }

    @objc func favoriteTapped() {
        isFavorited = !isFavorited
        if isFavorited {
            favoriteButton.tintColor = UIColor.red
        } else {
            favoriteButton.tintColor = UIColor(named: "ProColor")
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        configureCell()
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        outerView.layer.borderWidth = 1
        outerView.layer.cornerRadius = 20
        outerView.layer.borderColor = UIColor(named: "ProColor")?.cgColor
        
    }
    
    func configureCell() {
        if let item = item {
            let image = item.image ?? "image_not_available"
            let name = item.name ?? "---"
            let price = item.price ?? 0
            let isFavorite = item.isFavorite ?? false

            imageView.image = UIImage(named: image)
            nameLabel.text = name
            priceLabel.text = price.toDollarFormat()
            isFavorited = isFavorite
            favoriteButton.tintColor = isFavorite ? UIColor.red : UIColor(named: "ProColor")
        } else {
        }
    }

    
}
