import UIKit

extension Float {
    func formatAsRupiah() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.locale = Locale(identifier: "id_ID")

        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
