//: [Previous](@previous)

import Foundation

// func printData(with nama: String)

func add(x:Int, y:Int) -> () -> Int {
    var total = 0
    let a: () -> Int = {
        total = x + y
        return total
    }
    return a
}
var hasil = add(x: 10, y: 2)
print(hasil())



func changeVariable(name: inout String) {
    name = name + "Gomgom"
}
var name = "Kaleb "
changeVariable(name: &name)
print(name)


func compute(number: Int) -> (Int, Int, Int) {
    let square = number * number
    let cube = square * number
    
    return (number, square, cube)
}

let (number, square, cube) = compute(number: 5)
print(square, cube)


func greetMessage(_ name:String) {
    func displayName() {
        print("Good Morning \(name)")
    }
    displayName()
}
              
greetMessage("Kaleb")


// tidak disarankan karna makan banyak memori
func countDown(number: Int) {
    print(number)
    
    if number == 0 {
        print("Countdown Stops")
    } else {
        countDown(number: number - 1)
    }
}

countDown(number: 8)

// func display(number)





enum Hari {
    case senin, selasa, rabu, kamis, jumat, sabtu, minggu
}

func Checker(day: Hari) {
    print(day)
    switch(day){
    case .sabtu, .minggu:
        print("Hari Libur")
    default:
        print("Hari Kerja")
    }
    
}

var today = Hari.selasa
Checker(day: today)



enum Lampu: String {
    case hitam = "Hitam"
    case putih = "Putih"
    case merah = "Merah"
    
}
let hitam = Lampu.hitam.rawValue
print(hitam)


let currentNumber = "123a"

func check(){
    guard let number = Int(currentNumber) else {
        return
    }
    print(number)
}

check()

// testing
func Test() -> Bool {
    var a = 1
    return true
}

var b = Test()
print(b)


func fad(_: String, test:String, _:Int) {
    let test = "test"
        print()
}


