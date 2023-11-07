//
//  ExtFloat.swift
//  profileUI
//
//  Created by Phincon on 07/11/23.
//

import Foundation
import UIKit

extension Float {
    func toDollarFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD" // Set the currency code for US dollars
        numberFormatter.currencySymbol = "$ " // Set the currency symbol
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedString
        }

        return ""
    }
}
