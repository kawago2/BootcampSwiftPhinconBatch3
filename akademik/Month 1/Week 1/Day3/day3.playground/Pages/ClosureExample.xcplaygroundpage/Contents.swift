import Foundation

// contoh closure dalam class

class Calculator {
    var operation: ((Double, Double) -> Double)?
    
    var name: String = "Fahmi"
    
    var namaComputed: String {
        name+name
    }
    
    init() {
        operation = { (a, b) in
            return a + b
        }
    }
    
    func calculate(a: Double, b: Double) -> Double? {
        if let operation = operation {
            return operation(a, b)
        }
        return nil
    }
}


let calculator = Calculator()
let result = calculator.calculate(a: 5.0, b:3.0)
print(result ?? 0.0)

calculator.operation = { (a, b) in
    return a * b
}

let result2 = calculator.calculate(a: 5.0, b:3.0)
print(result2 ?? 0.0)


// contoh closure dalam function

func applyOperation(a: Double, b: Double, operation: (Double, Double) -> Double) -> Double {
    let result = operation(a, b)
    return result
}

let additionResult = applyOperation(a: 5.0, b:3.0) { (a, b) in
    return a + b
}

print("Hasil Penambahan: \(additionResult)")

let multiplicationResult = applyOperation(a: 5.0, b: 3.0) { (a, b) in
    return a * b
}

print("Hasil Perkalian: \(multiplicationResult)")


