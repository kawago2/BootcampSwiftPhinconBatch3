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
    
    public func loadNib() -> UIView {
         let bundle = Bundle(for: type(of: self))
         let nibName = type(of: self).description().components(separatedBy: ".").last!
         let nib = UINib(nibName: nibName, bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
     }
    
    func setRoundedBorder(cornerRadius: CGFloat, borderWidth: CGFloat = 1.0, borderColor: UIColor = .black) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
    
    func makeCircle() {
        self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2.0
        self.layer.masksToBounds = true
    }
     
}
