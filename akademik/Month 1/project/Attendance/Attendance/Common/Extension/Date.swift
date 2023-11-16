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
}
