//
//  Constants.swift
//  profileUI
//
//  Created by Phincon on 30/10/23.
//

import Foundation
import UIKit


enum BaseConstant {
    static let baseUrl = "https://jsonplaceholder.typicode.com/todos"
}

enum Constants {
    static let topCellIdentifier = "TopCell"
    static let middleCellIdentifier = "MiddleCell"
    static let bottomCellIdentifier = "BottomCell"
    static let coreDataEntityName = "Foods"
    static let coreDataFileName = "DataModel"
}

enum LocalStorage {
    static let Base = UserDefaults.standard
}

enum IconSystem {
    static let home = UIImage(systemName: "house")
    static let profile = UIImage(systemName: "person.fill")
    static let dashboard = UIImage(systemName: "paperplane")
}

enum FontPoppins {
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    static func italic(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Italic", size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
}
