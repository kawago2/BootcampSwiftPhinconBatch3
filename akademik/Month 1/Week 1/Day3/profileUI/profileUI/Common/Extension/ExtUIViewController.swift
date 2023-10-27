//
//  ExtUIViewController.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//

import Foundation
import UIKit

extension UIViewController {
    func hiddenBack() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    func setNavTitle(title: String) {
        navigationItem.title = title
    }
}

