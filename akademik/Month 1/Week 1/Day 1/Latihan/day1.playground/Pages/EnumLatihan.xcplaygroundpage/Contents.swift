import Foundation

enum Coin: String {
    case penny = "Penny"
    case nickel = "Nickel"
    case dime = "Dime"
    case quarter = "Quarter"
    
    func value() -> Double {
        switch self {
        case .penny:
            return 0.01
        case .nickel:
            return 0.05
        case .dime:
            return 0.10
        case .quarter:
            return 0.25
        }
    }
}

let coin1 = Coin.penny
let coin2 = Coin.quarter

print("The value of \(coin1.rawValue) is $\(coin1.value())")
print("The value of \(coin2.rawValue) is $\(coin2.value())")

