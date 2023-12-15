import Foundation
import DropDown

// MARK: - Configure UI DropDown
extension DropDown {
    func setupUI(fontSize : CGFloat) {
        self.textFont = UIFont(name: FontName.medium, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        self.backgroundColor = UIColor.white
        self.cornerRadius = 20
        self.selectionBackgroundColor = UIColor.lightGray
    }
}
