import Foundation

// contoh function generic

func displayData<T>(data: T) {
    print("Generic Function")
    print("Data Passed:", data)
}

// jika menggunakan generic data dapat disi dengan typedata apapun (String, Int, Bool, Dll.)
displayData(data: "Swift")
displayData(data: 5)
displayData(data: true)
displayData(data: 2.00)


// contoh class generic

class Information<T> {
    var data: T
    
    init(data: T) {
        self.data = data
    }
    
    func getData() -> T {
        return self.data
    }
}

var intObj = Information<Int>(data: 6)

print("Hasilnya",intObj.getData())

var strObj = Information<String>(data: "Swift")
print("Hasilnya",strObj.getData())


// contoh constrains in generic function
func addition<T: Numeric>(num1: T, num2: T) {
    print("Sum", num1 + num2)
}


// dipake dengan value yang tipenya numeric
addition(num1: -0.5, num2: 10)


// contoh membuat list kosong dengan kelompok menggunakan collection
var list1: Array<Int> = []
var list2: Array<String> = []
print(list2)
