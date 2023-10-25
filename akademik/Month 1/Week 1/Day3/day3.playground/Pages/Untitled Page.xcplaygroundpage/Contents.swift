import Foundation



// contoh penggunakan private init
class Common {
    static let shared = Common()
    private init() {}
}

print(Common.shared)


