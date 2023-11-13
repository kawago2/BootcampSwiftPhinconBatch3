//
//  SliderCell.swift
//  Attendance
//
//  Created by Phincon on 13/11/23.
//

import UIKit

class SliderCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var image: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initData(img: String?) {
        if let image = img {
            imageView.image = UIImage(named: image)
        } else {
            imageView.image = UIImage(named: "image_not_available")
        }
    }
}
