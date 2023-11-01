//
//  ExtUIView.swift
//  profileUI
//
//  Created by Phincon on 26/10/23.
//

import Foundation
import UIKit

extension UIView {
    func setShadow(cornerRadius: CGFloat = 20, shadowColor: CGColor = UIColor.black.cgColor, shadowOpacity: Float = 1.0, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowRadius: CGFloat = 5.0, clipsToBounds: Bool = false) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = clipsToBounds
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }    
}
