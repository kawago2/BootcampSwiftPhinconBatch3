import Foundation
import RxSwift
import RxCocoa

struct ItemModel : Codable, Hashable, Identifiable {
    var id = UUID()
    var image: String?
    var name: String?
    var price: Float?
    var isFavorite: Bool?
    var quantity:Int = 1
}

class DashboardViewModel {
    
    let disposeBag = DisposeBag()
    
    // Input
    let searchText = BehaviorRelay<String>(value: "")
    
    // Output
    let filteredData: Driver<[ItemModel]>
    
    init() {
        let fetchData = BehaviorRelay<[ItemModel]>(value: [])
        
        filteredData = Observable.combineLatest(fetchData, searchText.asObservable())
            .map { (fetchData, query) in
                return fetchData.filter { item in
                    guard let name = item.name else {
                        return false
                    }
                    let lowercaseName = name.lowercased()
                    let lowercaseQuery = query.lowercased()
                    return lowercaseName.contains(lowercaseQuery)
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
