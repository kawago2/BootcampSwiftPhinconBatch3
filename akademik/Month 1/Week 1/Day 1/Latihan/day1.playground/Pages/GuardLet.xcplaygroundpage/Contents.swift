import Foundation

let possibleNumber = "12a3"



func checkNumber() {
    guard let number = Int(possibleNumber) else {
        print("The number was invalid")
        return
    }
    print(number)
}

checkNumber()
