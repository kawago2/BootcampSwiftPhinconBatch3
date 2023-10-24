import Foundation

struct Product {
    var id: Int
    var name: String
    var price: Int
    var stock: Int
}

class Store {
    var availableProduct: [Product]
    
    init() {
        self.availableProduct = []
    }
    
    func listAvailableProduct() {
        print("Product yang tersedia:")
        for product in availableProduct {
            print("\(product.id) \(product.name) - Rp.\(product.price) - \(product.stock)")
        }
    }
}

class Customer {
    
}
