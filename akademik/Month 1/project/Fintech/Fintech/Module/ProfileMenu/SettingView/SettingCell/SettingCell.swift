//
//  SettingCell.swift
//  Fintech
//
//  Created by Phincon on 08/12/23.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupUI() {
        selectionStyle = .none
    }
    
    func setup(name: String, description: String?) {
        nameLabel.text = name
        
        if let description = description {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.text = ""
            descriptionLabel.isHidden = true
        }
    }
    
}
