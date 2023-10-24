import Foundation


enum CustomError: Error {
    case notNumber
    case limit
}

class ATM {
    static var balance: Double = 0

    static func checkBalance() {
        print("\tYour current balance is \(balance)")
    }

    static func withdrawMoney(amount: Double) throws -> Double {
        if balance == 0 {
            print("\tYour current balance is zero.")
            print("\tYou cannot withdraw!")
            print("\tYou need to deposit money first.")
        } else if balance <= 500 {
            print("\tYou do not have sufficient money to withdraw")
            print("\tCheck your balance to see your money in the bank.")
        } else if amount > balance {
            print("\tThe amount you withdraw is greater than your balance")
            print("\tPlease check the amount you entered.")
        } else {
            balance -= amount
            print("\n\tYou withdraw the amount of Money \(amount)")
        }
    }

    static func depositMoney(amount: Double) {
        balance += amount
        print("\tYou deposited the amount of \(amount)")
    }
}

ATM.depositMoney(amount: 10000)
ATM.checkBalance()
ATM.withdrawMoney(amount: 5000)
ATM.checkBalance()







             

