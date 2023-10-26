//
//  ExtUIView.swift
//  profileUI
//
//  Created by Phincon on 26/10/23.
//

import Foundation
import UIKit

extension UIView {
    func setRadius(){
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5
        self.clipsToBounds = false
    }
}
