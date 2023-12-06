import UIKit

extension UIImageView {
    func setCircleNoBorder() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
