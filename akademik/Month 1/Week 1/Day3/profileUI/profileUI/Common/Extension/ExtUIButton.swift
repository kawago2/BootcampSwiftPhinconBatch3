//
//  ExtUIButton.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//

import Foundation
import UIKit

extension UIButton {
    func setRoundedBorder(cornerRadius: CGFloat = 15, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.black, clipsToBounds: Bool = true) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = clipsToBounds
    }
}

