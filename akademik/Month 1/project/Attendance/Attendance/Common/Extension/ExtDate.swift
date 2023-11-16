import UIKit

extension Date {
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isGreaterOrEqualThan(_ date: Date) -> Bool {
        return self >= date
    }
    
    func isLessThan(_ date: Date) -> Bool {
        return self < date
    }
    
    func isLessThanOrEqualThan(_ date: Date) -> Bool {
        return self <= date
    }
    
    func formattedFullDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formattedFullTimeString() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from: self)
    }
    
    func formattedShortDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }

    func formattedShortTimeString() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: self)
    }
}
