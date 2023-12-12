import UIKit

// MARK: - AttributeKey Enum
enum AttributeKey {
    static let foregroundColor = NSAttributedString.Key.foregroundColor
}

// MARK: - InsightViewModel
class InsightViewModel {
    
    // MARK: - Properties
    let titleNavigationBar = "Insights"
    
    // MARK: - Methods
    func makeAttributedString(with text: String, color: UIColor) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            AttributeKey.foregroundColor: color,
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
