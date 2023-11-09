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
            let sectionToReload = 1 // Section index to reload
            let indexSet = IndexSet(integer: sectionToReload) // Create an index set for the section
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
        //        initCoreData()
        fetchCoreData()
        //        cleanCoreData()
    }
    
    func initCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        for item in listFood {
            let entity = NSEntityDescription.entity(forEntityName: "Foods", in: context)
            let newFood = NSManagedObject(entity: entity!, insertInto: context)
            newFood.setValue(item.id, forKey: "id")
            newFood.setValue(item.name, forKey: "name")
            newFood.setValue(item.image, forKey: "image")
            newFood.setValue(item.price, forKey: "price")
            
            do {
                try context.save()
            } catch {
                print("Failed saving: \(error)")
            }
        }
    }
    
    func fetchCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Foods")
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            if let foods = fetchedResults as? [NSManagedObject] {
                for food in foods {
                    if let name = food.value(forKey: "name") as? String,
                       let id = food.value(forKey: "id") as? UUID,
                       let image = food.value(forKey: "image") as? String,
                       let price = food.value(forKey: "price") as? Float {
                        let item = ItemModel(id: id,image: image, name: name, price: price)
                        fetchData.append(item)
                    }
                }
            }
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    func cleanCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Foods")
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            if let foods = fetchedResults as? [NSManagedObject] {
                for food in foods {
                    context.delete(food)
                }
                
                try context.save()
            }
        } catch {
            print("Failed to clean data: \(error)")
        }
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
            .throttle(.microseconds(1000), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] query -> Observable<[ItemModel]> in
                
                guard let self = self else { return Observable.empty() }
                let filteredData = self.fetchData.filter { item in
                    if let name = item.name, !name.isEmpty {
                        let lowercaseName = name.lowercased()
                        let lowercaseQuery = query.lowercased()
                        return lowercaseName.contains(lowercaseQuery)
                    }
                    return false
                }
                return Observable.just(filteredData).observe(on: MainScheduler.instance)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! TopCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCell", for: indexPath) as! MiddleCell
            cell.delegate = self
            cell.listFood = searchText.isEmpty ? fetchData : filteredData
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BottomCell", for: indexPath) as! BottomCell
            var sum: Float = 0
            if listChart.isEmpty == false {
                for list in listChart {
                    sum += list.price ?? 0.0
                }
            }
            cell.manyItem = listChart.count
            cell.totalPrice = sum
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

extension DashboardViewController : MiddleCellDelegate , TopCellDelegate , CartViewDelegate{
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
        vc.data = item
        navigationController?.pushViewController(vc, animated: true)
    }
}




