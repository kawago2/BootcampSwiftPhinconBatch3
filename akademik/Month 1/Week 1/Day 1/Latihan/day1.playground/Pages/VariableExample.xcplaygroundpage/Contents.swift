import Foundation

var name: String = "Kaleb"  // contoh deklarasi
var greeting = "playground" // contoh tanpa deklarasi

name = "Gomgom"

print("Nama Saya Adalah", name, "Hello \(greeting)")


var number: Int = 10
number = 11

print("Umur saya \(number) tahun")


// contoh deklarasi variable dengan nilai kosong
var namaKelas: String = String()
var jumlahHewan: Int = Int()

// namaKelas = "Kelas Fisika"

if (namaKelas.isEmpty) {
    print("Data Kosong")
} else {
    print(namaKelas)
}

// contoh deklarasi yang tidak bisa diubah / const
let hariLibur: String = "Minggu"
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"

// jika deklarasi banyak variable
var red, green, blue: Double

// penggunaan semicolons (code dalam inline / satu line)
let cat = "🐱"; print(cat)

// contoh typealias
typealias AudioSample = UInt16
var maxAmp = UInt16.min

// contoh deklasi boolean
let isConnect: Bool = false

if isConnect {
    print("Has been Connected")
    
} else {
    print("Has been Disconnected")
}


// contoh tuples
var http404Error: (Int, String, Double) = (404, "Not Found", 5.3)

http404Error.0 = 201
http404Error.1 = "Created"

var ( statusCode, statusMessage, doubleNumber ) = http404Error

print("The status code is \(statusCode)")
print("The status code is \(statusMessage)")

// contoh array
var arrayHewan: [String] = ["Sapi", "Babi", "Kerbau", "Ayam"]

print(arrayHewan[0])

for record in arrayHewan {
    print(record)
}

for i in 0..<arrayHewan.count {
    print(arrayHewan[i])
}










