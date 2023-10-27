//
//  ExtUIButton.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//

import Foundation
import UIKit

extension UIButton {
    func setRoundedBorder() {
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
    }
}
