import UIKit

extension UIImageView {
    func setCircleNoBorder() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func setCircleWithBorder(borderColor: UIColor = .black, borderWidth: CGFloat = 1) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }

}
