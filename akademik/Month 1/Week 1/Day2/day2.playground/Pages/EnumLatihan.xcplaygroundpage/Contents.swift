//: [Previous](@previous)

import Foundation

enum Season: CaseIterable {
    case spring, summer, autumn, winter
}


var currentSeason: Season = .summer
print("Current Season:", currentSeason)

for xSeason in Season.allCases {
    print(xSeason)
}



enum PizzaSize {
    case small, medium, large
}
var size = PizzaSize.medium

switch(size){
    case .small:
        print("i ordered a small size pizza")
case .medium:
    print("i ordered a medium size pizza")
case .large:
    print("i ordered a large size pizza")
}


enum Size : Int {
    case small = 10
    case medium = 12
    case large = 14
}
var result = Size.small
    .rawValue
print(result)


enum Laptop {
    case name(String)
    
    case price (Int)
}
var brand = Laptop.name("Razer")

