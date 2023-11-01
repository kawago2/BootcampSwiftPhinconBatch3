//
//  Constants.swift
//  profileUI
//
//  Created by Phincon on 30/10/23.
//

import Foundation
import UIKit

enum IconSystem {
    static let home = UIImage(systemName: "house")
    static let profile = UIImage(systemName: "person.fill")
    static let dashboard = UIImage(systemName: "paperplane")
}

enum FontPoppins {
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
