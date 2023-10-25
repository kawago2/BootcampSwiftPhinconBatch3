import Foundation



// Superclass
class Vehicle {
    var speed: Double
    
    init(speed:Double) {
        self.speed = speed
    }
    
    func descSpeed() -> String {
        return "Kecepatan: \(speed) km/jam"
    }
}

// Subclass

class Car: Vehicle {
    var numberofDoors: Int
    
    init(speed: Double, numberofDoors: Int) {
        self.numberofDoors = numberofDoors
        super.init(speed: speed)
    }
    
    func descPintu() -> String {
        return "Pintu: \(numberofDoors)"
    }
}

let myCar = Car(speed: 100.0, numberofDoors: 4)

print(myCar.descPintu())
print(myCar.descSpeed())
