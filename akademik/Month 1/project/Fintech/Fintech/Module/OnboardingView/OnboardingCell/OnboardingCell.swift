//
//  OnboardingCell.swift
//  Fintech
//
//  Created by Phincon on 01/12/23.
//

import UIKit

// MARK: - OnboardingCell
class OnboardingCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Configuration
    func configureImage(image: String) {
        imageView.image = UIImage(named: image)
    }

}
