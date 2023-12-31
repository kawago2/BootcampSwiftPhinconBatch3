import Foundation
import UIKit

extension UIImageView {
    func setCircleBorder() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func setRoundedBorder() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.black.cgColor
    }
    func setCircleNoBorder() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

