//
//  OnboardingCell.swift
//  Fintech
//
//  Created by Phincon on 01/12/23.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureImage(image: String) {
        imageView.image = UIImage(named: image)
    }

}
