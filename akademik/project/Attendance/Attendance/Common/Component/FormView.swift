//
//  FormView.swift
//  Attendance
//
//  Created by Phincon on 28/11/23.
//

import Foundation
import UIKit

class FormView: UIView {
    
    var cornerRadius: CGFloat = 10
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setShadow()
    }
}
