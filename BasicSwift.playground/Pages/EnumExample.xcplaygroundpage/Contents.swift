//: [Previous](@previous)
import Foundation

enum Days: String, CaseIterable {
case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    
    
    // fungsi tambahan
    func description() -> String {
        switch self {
        case .Sunday, .Saturday: // mirip if
            return "Hari Libur"
        default: // mirip kaya else
            return "Hari kerja"
        }
    }
}


var namaHari: Days = Days.Friday

print(Days.allCases.count)

for direction in Days.allCases {
    print(direction.description())
}
print(namaHari.description())


//: [Next](@next)
