//
//  BannerCell.swift
//  profileUI
//
//  Created by Phincon on 30/10/23.
//

import UIKit

protocol BannerCellDelegate: AnyObject {
    func didTapDetailsButton(in cell: BannerCell)
}


class BannerCell: UICollectionViewCell {

    @IBOutlet weak var buttonDetails: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: BannerCellDelegate?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
    }

    func setup() {
        buttonDetails.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
    }
    
    @objc func detailsButtonTapped() {
        delegate?.didTapDetailsButton(in: self)
    }
    
    
    func configureData(data: String?) {
        if let image = UIImage(named: data ?? "image_not_available") {
            self.imageView.image = image
        }
    }
}
