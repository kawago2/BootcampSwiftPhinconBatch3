import Foundation
import UIKit

class DetailsViewModel {
    private var data: ItemModel
    var isFavorited: Bool
    
    init(data: ItemModel) {
        self.data = data
        self.isFavorited = data.isFavorite ?? false
    }
    
    var name: String {
        return data.name ?? "Not Found"
    }
    
    var price: String {
        return data.price?.toDollarFormat() ?? 0.toDollarFormat()
    }
    
    var image: UIImage? {
        return UIImage(named: data.image ?? "image_not_available")
    }
    
    func toggleFavorite() {
        isFavorited = !isFavorited
    }
}
