import UIKit
import CoreData
import RxSwift
import RxCocoa

class DashboardViewController: BaseViewController  {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var listFood: [ItemModel] = []
    private var fetchData: [ItemModel] = []
    private var listChart: [ItemModel] = []
    private var filteredData: [ItemModel] = []
    private var combinedCart: [UUID: ItemModel] = [:]
    private var searchText = ""
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadData()
        fetchCoreData()
    }
}

// MARK: - Core Data Operations

extension DashboardViewController {
    private func initCoreData() {
        CoreDataManager.shared.saveToCoreData(listFood)
    }
    
    private func fetchCoreData() {
        fetchData = CoreDataManager.shared.fetchFromCoreData()
    }
    
    private func cleanCoreData() {
        CoreDataManager.shared.cleanCoreData()
    }
}

// MARK: - Handling Data

extension DashboardViewController {
    private func loadData() {
        listFood.append(ItemModel(image: "fish_curry", name: "Fish Curry", price: 10, isFavorite: true))
        listFood.append(ItemModel(image: "beef_pizza", name: "Beef Pizza", price: 15, isFavorite: false))
        listFood.append(ItemModel(image: "vagatale_salad", name: "Vagatale Salad", price: 5, isFavorite: false))
        listFood.append(ItemModel(image: "chicken_ball", name: "Chicken Ball", price: 25, isFavorite: true))
    }
    
   private func combineItemsInCart() {
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
}

// MARK: - Table View Configure

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource  {
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        tableView.registerCellWithNib(TopCell.self)
        tableView.registerCellWithNib(MiddleCell.self)
        tableView.registerCellWithNib(BottomCell.self)
    }
    
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

// MARK: - Cart Button Config

extension DashboardViewController: CartViewDelegate, TopCellDelegate {
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
    
    
}


// MARK: - Search Bar Config

extension DashboardViewController : MiddleCellDelegate, BottomCellDelegate {
    func textFieldDidChange(_ newText: String) {
        setupRxSearch(newText: newText)
    }
    
    private func setupRxSearch(newText: String) {
        let query = newText
        searchText = query

        let filteredData = self.fetchData.filter { item in
            guard let name = item.name else {
                return false
            }
            let lowercaseName = name.lowercased()
            let lowercaseQuery = query.lowercased()
            return lowercaseName.contains(lowercaseQuery)
        }

        self.filteredData = filteredData
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let sectionToReload = 1
            let indexSet = IndexSet(integer: sectionToReload)
            self.tableView.reloadSections(indexSet, with: .automatic)
        }
    }
}

// MARK: - Card Item Handle

extension DashboardViewController {
    func didTapAddButton(_ item: ItemModel) {
        listChart.append(item)
        tableView.reloadData()
        
    }
    
    func didSelectItem(_ item: ItemModel) {
        let vc = DetailsViewController()
        vc.viewModel = DetailsViewModel(data: item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
}



