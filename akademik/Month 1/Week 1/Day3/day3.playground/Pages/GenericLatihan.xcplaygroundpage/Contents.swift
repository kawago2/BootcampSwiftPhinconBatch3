//: [Previous](@previous)

import Foundation


// generic class

class Stack<T> {
    var items = [T]()
    
    func push(item: T) {
        items.append(item)
    }
    
    func pop() -> T? {
        return items.popLast()
    }
}

// contoh array dengan collection Int
let intStack = Stack<Int>()
print(intStack.items)
intStack.push(item: 2)
print(intStack.items)
intStack.push(item: 7)
print(intStack.items)
intStack.pop()
print(intStack.items)

// contoh array dengan collection String
let strStack = Stack<String>()
print(strStack.items)
strStack.push(item: "Hello")
print(strStack.items)
strStack.push(item: "World")
print(strStack.items)



// generic func

func swapValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}


var x = 5
var y = 10

swap(&x, &y)

print("\(x) \(y)")


var str1 = "Hello"
var str2 = "World"

swapValues(&str1, &str2)

print("\(str1) \(str2)")
