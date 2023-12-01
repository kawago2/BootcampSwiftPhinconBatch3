import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func setShadow(cornerRadius: CGFloat = 30, shadowColor: CGColor = UIColor.black.cgColor, shadowOpacity: Float = 0.3, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowRadius: CGFloat = 2, clipsToBounds: Bool = false) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = clipsToBounds
    }
}
