class Customer {
    var name: String
    var balance: Int
    var purchasedItems: [String]
    
    init(name: String, balance: Int) {
        self.name = name
        self.balance = balance
        self.purchasedItems = []
    }
    
    func buy(itemName: String, price: Int, completion: (Bool, String) -> Void) {
        if balance >= price {
            balance -= price
            purchasedItems.append(itemName)
            completion(true, "Pembelian sukses: \(itemName)")
        } else {
            completion(false, "Saldo tidak mencukupi untuk membeli \(itemName)")
        }
    }
    
    func showPurchasedItems() {
        print("\(name) telah membeli barang-barang berikut:")
        for item in purchasedItems {
            print("- \(item)")
        }
    }
}

struct Product {
    var name: String
    var price: Int
}

class Store {
    var availableProducts: [Product]
    
    init() {
        availableProducts = []
    }
    
    func listAvailableProducts() {
        print("Produk yang tersedia:")
        for product in availableProducts {
            print("\(product.name) - \(product.price) credits")
        }
    }
    
    func sellProduct(productName: String, to customer: Customer, completion: (Bool, String) -> Void) {
        if let productIndex = availableProducts.firstIndex(where: { $0.name == productName }) {
            let product = availableProducts[productIndex]
            customer.buy(itemName: product.name, price: product.price) { success, message in
                if success {
                    availableProducts.remove(at: productIndex)
                    completion(true, "Penjualan sukses: \(productName)")
                } else {
                    completion(false, message)
                }
            }
        } else {
            completion(false, "Produk \(productName) tidak tersedia di toko.")
        }
    }
}

// Contoh penggunaan
let alice = Customer(name: "Alice", balance: 500)
let bob = Customer(name: "Bob", balance: 300)

var store = Store()
store.availableProducts = [Product(name: "Laptop", price: 400), Product(name: "Smartphone", price: 200)]

store.listAvailableProducts()

store.sellProduct(productName: "Laptop", to: alice) { success, message in
    if success {
        print(message)
    } else {
        print(message)
    }
}

store.sellProduct(productName: "Smartphone", to: bob) { success, message in
    if success {
        print(message)
    } else {
        print(message)
    }
}

alice.showPurchasedItems()
bob.showPurchasedItems()

