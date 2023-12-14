import UIKit
import DropDown

extension DropDown {
    func setupUI(fontSize : CGFloat) {
        self.textFont = UIFont(name: "Avenir", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        self.backgroundColor = UIColor.white
        self.cornerRadius = 20
        self.selectionBackgroundColor = UIColor.lightGray
    }
}
