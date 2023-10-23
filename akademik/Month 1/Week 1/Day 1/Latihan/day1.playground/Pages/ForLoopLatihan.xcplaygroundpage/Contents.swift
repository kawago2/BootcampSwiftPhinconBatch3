import Foundation

// Contoh penggunaan for-in loop dengan array of numbers
let numbers = [1, 2, 3, 4, 5]
for number in numbers {
    print("Square of \(number) is \(number * number)")
}
print("==================")

// Contoh penggunaan for-in loop dengan dictionary
let scores = ["John": 85, "Sarah": 92, "Mike": 78, "Emily": 96]
for (name, score) in scores {
    print("\(name)'s score is \(score)")
}
print("==================")

// Contoh penggunaan while loop untuk menghitung mundur
var countdown = 10
while countdown > 0 {
    print("Countdown: \(countdown)")
    countdown -= 1
    
}
if countdown == 0 {
    print("Blast off!")
}












