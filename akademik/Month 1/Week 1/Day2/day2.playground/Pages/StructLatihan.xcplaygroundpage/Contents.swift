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
enum Identity2 {
    case student
    case teacher
    case employee
}

// Struct yang memiliki beberapa tipe data
struct Person: Equatable {
    var name: String
    var age: Int
    var role: Identity2
    

    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name &&
        lhs.age == rhs.age &&
        lhs.role == rhs.role
    }
    func details(){
        print("""
Name: \(name)
Age: \(age)
Role: \(role)
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
    
}


// Contoh penggunaan struct
var person1 = Person(name: "Kaleb", age: 30, role: .employee)
let person2 = Person(name: "Kaleb", age: 30, role: .employee)
let person3 = Person(name: "Kaleb", age: 30, role: .teacher)

person1.changeName(name: "Edward")
person1.changeAge(age: 27)
person1.isTecher()

person1.details()
person2.details()
person3.details()

if (person1 == person2 && person1 == person3 && person2 == person3) {
    print("All are equal")
} else {
    print("person1 and person3 are not equal")
}

