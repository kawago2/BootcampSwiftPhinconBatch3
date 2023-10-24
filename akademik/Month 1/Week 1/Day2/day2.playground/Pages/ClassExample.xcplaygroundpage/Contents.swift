/*
 class bisa inheritance
 class (reference type)
 class ada initialization
 class memory leakkk
 
 */


import Foundation

protocol Drawable {
    func draw()
}

class Square {
    var panjang: Double
    var lebar: Double
    
    init(panjang: Double, lebar: Double) {
        self.panjang = panjang
        self.lebar = lebar
    }
    
    func luasSquare() -> Double {
        return panjang * lebar
        
    }
    
    
}

class Circle: Square{
    var radius: Double
    
    var area: Double {
        get {
            return Double.pi * radius * radius
        }
        set(newArea) {
            radius = sqrt(newArea / Double.pi)
        }
    }
    private init(radius: Double, panjang: Double, lebar: Double) {
        self.radius = radius
        super.init(panjang: panjang, lebar: lebar)
        
    }
    convenience init(radius:Double) {
        self.init(radius: radius, panjang: 10, lebar: 5)
    }
    
    override func luasSquare() -> Double {
        return radius * panjang * lebar
    }
    func draw() {
        print("Luas Lingkaran adalah \(self.luasSquare())")
    }
    
}

extension Circle: Drawable {
    
    func showDescription() {
        print("Luas Lingkaran adalah \(self.luasSquare())")
    }
}


var myCircle = Circle(radius: 10)

let calculatedArea = myCircle.area
print(calculatedArea)

myCircle.area = 50.0
print(myCircle.radius)
print(myCircle.area)


myCircle.showDescription()
myCircle.draw()
