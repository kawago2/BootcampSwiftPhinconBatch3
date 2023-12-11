import UIKit

enum AttributeKey {
    static let foregroundColor = NSAttributedString.Key.foregroundColor
}

class InsightViewModel {
    
    let titleNavigationBar = "Insights"
    
    func makeAttributedString(with text: String, color: UIColor) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            AttributeKey.foregroundColor: color,
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
