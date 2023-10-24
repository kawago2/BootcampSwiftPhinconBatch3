import Foundation

enum CustomError: Error {
    case notNumber
    case limit
    case zero
    case greaterLimit
}

class ATM {
    static var balance: Double = 0

    static func checkBalance() {
        print("\tYour current balance is \(balance)")
    }

    static func withdrawMoney(amount: Double) throws {
        if balance == 0 {
            throw CustomError.zero
        } else if balance <= 500 {
            throw CustomError.limit
        } else if amount > balance {
            throw CustomError.greaterLimit
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

func main() throws {
    var select = 0
    var play = true
    print("====================================================")
    print("\tWelcome to this simple ATM machine")
    print("====================================================")
    print()
    while play {
        print("\tPlease select ATM Transactions")
        print("\tPress [1] Deposit")
        print("\tPress [2] Withdraw")
        print("\tPress [3] Balance Inquiry")
        print("\tPress [4] Exit")

        print("\n\tWhat would you like to do? ", terminator: "")
        if let input = readLine(), let inputInt = Int(input) {
            select = inputInt
        } else {
            throw CustomError.notNumber
        }
        switch select {
        case 1:
            print("\tEnter the amount to deposit: ", terminator: "")
            if let input = readLine(), let amount = Double(input) {
                ATM.depositMoney(amount: amount)
            } else {
                print("Invalid input. Please enter a valid number.")
            }
        case 2:
            print("\tEnter the amount to withdraw: ", terminator: "")
            if let input = readLine(), let amount = Double(input) {
                do {
                    try ATM.withdrawMoney(amount: amount)
                } catch CustomError.limit {
                    print("\tYou do not have sufficient money to withdraw")
                    print("\tCheck your balance to see your money in the bank.")
                } catch CustomError.zero{
                    print("\tYour current balance is zero.")
                    print("\tYou cannot withdraw!")
                    print("\tYou need to deposit money first.")
                } catch CustomError.greaterLimit {
                    print("\tThe amount you withdraw is greater than your balance")
                    print("\tPlease check the amount you entered.")
                } catch {
                    print("An error occurred: \(error)")
                }
            } else {
                print("Invalid input. Please enter a valid number.")
            }
        case 3:
            ATM.checkBalance()
        case 4:
            print("\tExiting....")
            play = false
            
        default:
            print("\tInvalid selection. Please choose a valid option (1-4).")
        }
        print("====================================================")
    }
}
    
do {
    let result = try main()
} catch CustomError.notNumber {
    print("\tinput not number")
}

