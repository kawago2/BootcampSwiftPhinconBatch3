//: [Previous](@previous)

import Foundation

func greet(person: String, greeting: (String) -> String) -> String {
    let message = greeting(person)
    print(message)
    return message
}

func simpleGreeting(name: String) -> String {
    return "Hello, \(name)"
}

greet(person: "Kaleb", greeting: simpleGreeting)

greet(person: "Kaleb", greeting: { _ in
    return "Hello, SSS"
})
// $0 untuk menampilkan parameter pertama dari sebuah fungsi
let data = greet(person: "Kaleb") {$0}
print(data)

// Mendefinisikan closure yang mengalikan dua angka
let multiply: (Int, Int) -> Int = { a, b in
    return a * b
}

// Menggunakan closure
let result = multiply(5, 3)
print(result)

let names = ["Alice", "Bob", "Charlie", "David"]

// ubah urutan array
let sortedNames = names.sorted { (name1, name2) in
    return name1 > name2
}
print(sortedNames)


func doLoop(number_ num:Int, onLoop: (Int) -> Void) {
    print("closure")
    for i: Int in 0..<num {
        onLoop(i)
    }
}
