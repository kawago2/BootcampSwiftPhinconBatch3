import Foundation


/*
 default syntax for closure
 {
    (parameters) −> return type in
    statements
 }
 */
func greet(person: String, greeting: (String) -> String) -> String {
    let message = greeting(person)
    print(message)
    return message
}

func simpleGreeting(name: String) -> String {
    return "Hello, \(name)"
}

// Menggunakan simpleGreeting sebagai closure
greet(person: "Kaleb", greeting: simpleGreeting)

// Menggunakan closure tanpa nama (anonymous) untuk memberikan pesan statis
greet(person: "Kaleb", greeting: { _ in
    return "Hello, SSS"
})

// Menggunakan trailing closure dengan $0 untuk menyederhanakan sintaks
let data = greet(person: "Kaleb") { $0 }
print(data)

// Contoh lain dengan closure yang berbeda
let enthusiasticGreeting: (String) -> String = { name in
    return "Hello, \(name)!"
}

greet(person: "Alice", greeting: enthusiasticGreeting)

// Closure yang menggabungkan dua nama
let combinedGreeting: (String) -> String = { name in
    let names = name.components(separatedBy: " ")
    return "Hello, \(names.first ?? "there") and \(names.last ?? "friend")!"
}

greet(person: "John Smith", greeting: combinedGreeting)

var greet = {
  print("Hello, World!")
}

greet()


let greetUser = { (name: String) in
    print("Hey there, \(name).")
}

greetUser("Kaleb")

// closure definition
var findSquare = { (num: Int) -> (Int) in
  var square = num * num
  return square
}

// closure call
var result = findSquare(3)

print("Square:",result)


// define a function and pass closure
func grabLunch(search: ()->()) {
  print("Let's go out for lunch")

  // closure call
  search()
}

// pass closure as a parameter
grabLunch(search: {
   print("Alfredo's Pizza: 2 miles away")
})

func grabLunch(message: String, search: ()->()) {
   print(message)
   search()
}

// use of trailing closure
grabLunch(message:"Let's go out for lunch")  {
  print("Alfredo's Pizza: 2 miles away")
}


// define a function with automatic closure
func display(greet: @autoclosure () -> ()) {
 greet()
}

// pass closure without {}
display(greet: print("Hello World!"))



var addClosures: (Int, Int) -> Int = {
    (number1: Int, number2: Int) in
    return number1 + number2
}

addClosures(4, 10)

var addClosuresTwo = {
    (number1: Int, number2: Int) -> Int in
    print("Hello")
    return number1 + number2 // return required
}

addClosuresTwo(2,7)

var addClosuresThree = {
    (number1: Int, number2: Int) in
    number1 + number2 // return not required
}

addClosuresThree(4, 6)


var addClosuresFour: (Int, Int) -> Int = {
    $0 + $1
}
addClosuresFour(4, 5)


var addWithClosures: (Int, Int) -> Int = { (number1: Int, number2: Int) in
    return number1 + number2
}

func returnClosure() -> ((Int, Int) -> Int) {
    return addWithClosures
}

let addClosure = returnClosure()
addClosure(4, 10)
let addClosureTwo = returnClosure()(4, 10)
print(addClosureTwo)

func returnClosureDirectly() -> ((Int, Int) -> Int) {
    return { (number1, number2) in number1 + number2 }
}
returnClosureDirectly()(4, 10)

func returnClosureDirectlyTwo() -> ((Int, Int) -> Int) {
    return { $0 + $1 }
}
returnClosureDirectlyTwo()(4, 10) // 14


// passing closure
func insertClosureBlock(closureBlock: () -> String) -> String {
    return closureBlock()
}

func hello() -> String {
    return "hello"
}
insertClosureBlock(closureBlock: hello)


insertClosureBlock { () in return "hello" }
insertClosureBlock { () in "hello" }
insertClosureBlock(closureBlock: { return "hello" })
insertClosureBlock(closureBlock: { "hello" })


// contoh lain dalam closure
// default closure
let hitung = {
   (num1: Int, num2: Int) -> Int in
   return num1 * num2
}

let hasil = hitung(9, 7)
print(hasil)
 
// closure asending order
func pesan(str1: String, str2: String) -> Bool {
   return str1 > str2
}

let string = pesan(str1: "Swift", str2: "Belajar")
print(string)

