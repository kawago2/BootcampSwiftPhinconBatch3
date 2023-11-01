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
        selectionStyle = .none
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        containerView.setShadow()
        imgMakanan.setRoundedBorder()
    }
    
    func configureData(data: ModelItem) {
        self.namaMakananLabel.text = data.nama ?? "Nama Tidak Tersedia"
        self.hargaMakananLabel.text = data.harga != nil ? data.harga?.toRupiahFormat() : "Harga Tidak Ada"
        if let image = UIImage(named: data.img ?? "image_not_available") {
            self.imgMakanan.image = image
        }
    }
}
