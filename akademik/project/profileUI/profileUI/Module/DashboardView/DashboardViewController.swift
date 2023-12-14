import UIKit
import CoreData
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
    
    var listFood: [ItemModel] = []
    var fetchData: [ItemModel] = []
    var listseparated: [ItemModel] = []
    var listChart: [ItemModel] = []
    var filteredData: [ItemModel] = []
    var combinedCart: [UUID: ItemModel] = [:]
    
    var searchText = "" {
        didSet {
            let sectionToReload = 1
            let indexSet = IndexSet(integer: sectionToReload)
            self.tableView.reloadSections(indexSet, with: .automatic)
        }
    }
    let disposeBag = DisposeBag()
    let textSubject = PublishSubject<String>()
    let searchSubject = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadData()
        fetchCoreData()
    }
    
    func initCoreData() {
        CoreDataManager.shared.saveToCoreData(listFood)
    }
    
    func fetchCoreData() {
        fetchData = CoreDataManager.shared.fetchFromCoreData()
    }
    
    func cleanCoreData() {
        CoreDataManager.shared.cleanCoreData()
    }
    
    func loadData() {
        listFood.append(ItemModel(image: "fish_curry", name: "Fish Curry", price: 10, isFavorite: true))
        listFood.append(ItemModel(image: "beef_pizza", name: "Beef Pizza", price: 15, isFavorite: false))
        listFood.append(ItemModel(image: "vagatale_salad", name: "Vagatale Salad", price: 5, isFavorite: false))
        listFood.append(ItemModel(image: "chicken_ball", name: "Chicken Ball", price: 25, isFavorite: true))
    }
    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        tableView.registerCellWithNib(TopCell.self)
        tableView.registerCellWithNib(MiddleCell.self)
        tableView.registerCellWithNib(BottomCell.self)
    }
    
    func combineItemsInCart() {
        combinedCart = [:]
        for item in listChart {
            if var existingItem = combinedCart[item.id] {
                existingItem.quantity += 1
                combinedCart[item.id] = existingItem
            } else {
                combinedCart[item.id] = item
            }
        }
        listChart = Array(combinedCart.values)
    }
    
    
    func setupRxSearch() {
        searchSubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] query -> Observable<[ItemModel]> in
                guard let self = self else { return Observable.empty() }
                
                let filteredData = self.fetchData.filter { item in
                    guard let name = item.name else {
                        return false
                    }
                    let lowercaseName = name.lowercased()
                    let lowercaseQuery = query.lowercased()
                    return lowercaseName.contains(lowercaseQuery)
                }
                return Observable.just(filteredData)
            }
            .subscribe(onNext: { [weak self] results in
                guard let self = self else { return }
                self.filteredData = results
            })
            .disposed(by: disposeBag)
    }
    
}


extension DashboardViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorColor = .clear
        let index = indexPath.section
        switch (index) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.topCellIdentifier, for: indexPath) as! TopCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.middleCellIdentifier, for: indexPath) as! MiddleCell
            cell.delegate = self
            cell.listFood = searchText.isEmpty ? fetchData : filteredData
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bottomCellIdentifier, for: indexPath) as! BottomCell
            var sum: Float = 0
            if listChart.isEmpty == false {
                for list in listChart {
                    sum += list.price ?? 0.0
                }
            }
            cell.manyItem = listChart.count
            cell.totalPrice = sum
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.section
        switch (index) {
        case 0:
            return 180
        case 1:
            let itemHeight: CGFloat = 250
            let itemsPerRow: Int = 2
            let rowCount = (searchText.isEmpty ? fetchData.count : filteredData.count + 1) / itemsPerRow
            let totalHeight = CGFloat(rowCount) * itemHeight
            return totalHeight
        case 2:
            return 64
        default:
            return 0
        }
    }
}

extension DashboardViewController : MiddleCellDelegate , TopCellDelegate , CartViewDelegate, BottomCellDelegate {
    
    func didButtonTapped() {
        combineItemsInCart()
        if combinedCart.isEmpty { return }
        let vc = CartViewController()
        vc.delegate = self
        vc.combinedCart = combinedCart
        vc.context = "BottomCell"
        vc.tableView?.reloadData()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapFilterButton() {
        print("filter clicked")
    }
    
    func textFieldDidChange(_ newText: String) {
        searchText = newText
        searchSubject.accept(newText)
        setupRxSearch()
    }
    
    func passDataCart(listChart: [ItemModel]) {
        self.listChart = listChart
        tableView.reloadData()
    }
    
    func didTapCartButton() {
        let vc = CartViewController()
        vc.delegate = self
        combineItemsInCart()
        vc.combinedCart = combinedCart
        vc.tableView?.reloadData()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func didTapAddButton(_ item: ItemModel) {
        listChart.append(item)
        tableView.reloadData()
        
    }
    
    // Implement the MiddleCellDelegate method to handle navigation
    func didSelectItem(_ item: ItemModel) {
        let vc = DetailsViewController()
        vc.viewModel = DetailsViewModel(data: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}




