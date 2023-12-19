import Foundation
// MARK: - Frequency Enum

enum Frequency: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
}

protocol PickDateViewDelegate: AnyObject {
    func passData(selectedDates: [Date])
}
