import UIKit
import DropDown

class DropDownManager {

    // MARK: - Properties
    public var dropDown: DropDown
    public var isShow = false

    // MARK: - Initialization
    init() {
        self.dropDown = DropDown()
        setupDropDown()
    }

    // MARK: - Public Methods
    public func showDropDown(from anchorView: UIView, dataSource: [String], selectionAction: @escaping (Int, String) -> Void) {
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource

        let anchorTotalHeight = anchorView.bounds.height + anchorView.layer.cornerRadius
        dropDown.bottomOffset = CGPoint(x: 0, y: anchorTotalHeight)

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            selectionAction(index, item)
            self.isShow = false
            self.dropDown.hide()
        }

        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.isShow = false
            self.dropDown.hide()
        }

        if !isShow {
            dropDown.show()
            isShow = true
        }
    }

    public func dismissDropDown() {
        if isShow {
            dropDown.hide()
            isShow = false
        }
    }

    // MARK: - Private Methods

    private func setupDropDown() {
        dropDown.dismissMode = .manual
        let fontSize = CGFloat(14)
        // Replace FontName.medium with a valid font name or use a system font
        dropDown.textFont = UIFont(name: "YourValidFontName", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 20
        dropDown.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        dropDown.shadowColor = .clear
        dropDown.selectionBackgroundColor = UIColor.lightGray
    }
}
