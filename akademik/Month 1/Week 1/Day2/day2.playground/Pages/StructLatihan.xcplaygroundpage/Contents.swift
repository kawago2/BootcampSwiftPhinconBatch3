//: [Previous](@previous)

import Foundation

// contoh identity

struct Person1 {
    var name: String
    var age: Int
    var address: String
    var identity: Identity

    func details(){
          print("""
Name: \(name)
Age: \(age)
Address: \(address)
""")
    }
}

struct Identity {
    var idNumber: String
    var passportNumber: String
    var ssn: String

    func details(){
          print("""
ID Number: \(idNumber)
Passport Number: \(passportNumber)
SSN: \(ssn)
""")
    }
}

let personInfo = Person1(name: "Kaleb Gomgom", age: 22, address: "JL Koja", identity: Identity(idNumber: "12345", passportNumber: "ABC123", ssn: "123-45-6789"))

personInfo.details()
personInfo.identity.details()


// Enum untuk tipe Identity
enum Identity2 : String {
    case student = "Student"
    case teacher = "Teacher"
    case employee = "Employee"
}

// Struct yang memiliki beberapa tipe data
struct Person: Equatable {
    var name: String
    var age: Int
    var role: Identity2
    var income: Int
    var residu: Int
    var history: [Int] = [Int]()
    
    init(name: String, age: Int, role:Identity2, income:Int, residu: Int = 0,history: [Int] = []) {
        self.name = name
        self.age = age
        self.role = role
        self.income = income
        self.residu = residu
        self.history = history
    }
     
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name &&
        lhs.age == rhs.age &&
        lhs.role == rhs.role
    }
    
    static func description() {
        print("desc")
    }
    
    func details(){
        print("""
            Name: \(name)
            Age: \(age)
            Role: \(role.rawValue)
            Income: \(income)
            Residu: \(residu)
            History: \(history)
            """
        )
    }
    
    mutating func changeName(name: String){
        self.name = name
    }
    
    mutating func changeAge(age: Int){
        self.age = age
    }
    
    mutating func isTecher(){
        self.role = .teacher
    }
    
    mutating func Paying(amount: Int) {
        if self.income >= amount {
            history.append(amount)
            var result = 0
            for i in history {
                result += i
            }
            self.residu = self.income - result
        } else {
            fatalError("Pay to high")
        }
       
    }
}


Person.description()

// Contoh penggunaan struct
var person1 = Person(name: "Kaleb", age: 30, role: .employee, income: 10000)
let person2 = Person(name: "Kaleb", age: 30, role: .employee, income: 20000)
let person3 = Person(name: "Kaleb", age: 30, role: .teacher, income: 30000)

person1.changeName(name: "Edward")
person1.changeAge(age: 27)
person1.isTecher()
person1.Paying(amount: 5000)
person1.Paying(amount: 200)

person1.details()
person2.details()
person3.details()

if (person1 == person2 && person1 == person3 && person2 == person3) {
    print("All are equal")
} else {
    print("person1 and person3 are not equal")
}

