import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel {
    
    let disposeBag = DisposeBag()
    
    // Input
    let searchText = BehaviorRelay<String>(value: "")
    
    // Output
    let filteredData: Driver<[ItemModel]>
    
    init() {
        let fetchData = BehaviorRelay<[ItemModel]>(value: [])
        
        // Assuming fetchData is initialized and updated elsewhere in your code.
        // You can replace it with the actual logic to fetch data.

        // Combine searchText with fetchData to get filteredData
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
