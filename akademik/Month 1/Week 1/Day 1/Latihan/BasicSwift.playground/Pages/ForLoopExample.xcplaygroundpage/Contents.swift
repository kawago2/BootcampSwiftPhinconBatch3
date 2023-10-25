

import Foundation
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
print("==================")

let names = ["Anna", "Alex", "Brian", "Jack"]
for i in 0..<(names.count) {
    print("Person \(i + 1) is called \(names[i])")
}
print("==================")

for name in names[2...] {
    if name == "Brian" {
        print(name + " Gokil")
    } else {
        print(name)
    }
}

print("==================")

for name in names[...2]{
    print(name)
}
print("==================")

for name in names[1...3]{
    print(name)
}
print("==================")



