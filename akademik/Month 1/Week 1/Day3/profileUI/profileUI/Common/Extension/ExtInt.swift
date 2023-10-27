//
//  ExtInt.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//

import Foundation
import UIKit

extension Int {
    func toRupiahFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "Rp."
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedString
        }
        
        return ""
    }
}
