/*
 struct =  type data
 hanya untuk object bukan view
 stuct digunakan untuk mengcopy variable
 struct lebih ringan dari class
 stuct immutable & mutable
 */


import Foundation

struct Point {
    var x: Int
    var y: Int
    
    init(xAxis:Int,yAxis:Int) {
        self.x = xAxis
        self.y = yAxis
    }
    
    func square() -> Int {
        return x * y
    }
}

var originalPoint = Point(xAxis:2, yAxis:12)
print(originalPoint)


struct MyStruct: Equatable, Codable {
    var property1: Int
    var property2: String
    var property3: String
    
    
    static func == (lhs: MyStruct, rhs: MyStruct) -> Bool {
        return lhs.property1 == rhs.property1 && lhs.property2 == rhs.property2
    }
}

