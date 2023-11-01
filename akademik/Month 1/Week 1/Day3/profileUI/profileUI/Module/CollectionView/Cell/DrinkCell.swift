//
//  DrinkCollectionViewCell.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//

import UIKit

class DrinkCell: UICollectionViewCell {
    @IBOutlet weak var drinkView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hargaLabel: UILabel!
    @IBOutlet weak var namaLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        drinkView.setShadow()
    }
    func configureData(data: ModelItem) {
        self.namaLabel.text = data.nama ?? "Nama Tidak Tersedia"
        self.hargaLabel.text = data.harga != nil ? data.harga?.toRupiahFormat() : "Harga Tidak Ada"
        if let image = UIImage(named: data.img ?? "image_not_available") {
            self.imageView.image = image
        }
    }
}
