import UIKit
import CoreData
class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var listFood: [ItemModel] = []
    var fetchData: [ItemModel] = []
    var listChart: [ItemModel] = []
    var filteredData: [ItemModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadData()
        //        setup()
        fetchCoreData()
        

    }
    
    // Add a method to filter your data based on the search text
    func filterData(with searchText: String) {
        filteredData = fetchData.filter { item in
            if let name = item.name {
                return name.lowercased().contains(searchText.lowercased())
            }
            return false
        }
        tableView.reloadData()
    }
    
    func setup() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        for item in listFood {
            let entity = NSEntityDescription.entity(forEntityName: "Foods", in: context)
            let newFood = NSManagedObject(entity: entity!, insertInto: context)
            
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
        
        // Create a fetch request for the "Foods" entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Foods")
        
        do {
            // Execute the fetch request
            let fetchedResults = try context.fetch(fetchRequest)
            
            if let foods = fetchedResults as? [NSManagedObject] {
                for food in foods {
                    if let name = food.value(forKey: "name") as? String,
                       let image = food.value(forKey: "image") as? String,
                       let price = food.value(forKey: "price") as? Float {
                        // You can use the retrieved data here
                        print("Name: \(name), Image: \(image), Price: \(price)")
                        let item = ItemModel(image: image, name: name, price: price)
                        fetchData.append(item)
                    }
                }
            }
        } catch {
            print("Failed to fetch data: \(error)")
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
}


extension DashboardViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorColor = .clear
        let index = indexPath.row
        switch (index) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! TopCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCell", for: indexPath) as! MiddleCell
            cell.delegate = self
            if filteredData.isEmpty {
                cell.listFood = fetchData
            } else {
                cell.listFood = filteredData
            }
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
        let index = indexPath.row
        switch (index) {
        case 0:
            return 180
        case 1:
            let itemHeight: CGFloat = 250
            let itemsPerRow: Int = 2
            let rowCount = (fetchData.count + 1) / itemsPerRow
            let totalHeight = CGFloat(rowCount) * itemHeight
            return totalHeight
        case 2:
            return 64
        default:
            return 0
        }
    }
}

extension DashboardViewController : MiddleCellDelegate , TopCellDelegate{    
    func didTapCartButton() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func didTapAddButton(_ item: ItemModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new NSManagedObject for the selected item
        let entity = NSEntityDescription.entity(forEntityName: "CartItems", in: context)
        let newItem = NSManagedObject(entity: entity!, insertInto: context)
        
        newItem.setValue(item.name, forKey: "name")
        newItem.setValue(item.image, forKey: "image")
        newItem.setValue(item.price, forKey: "price")
        
        do {
            // Save the new item to Core Data
            try context.save()
            
            // Add the item to the listChart array
            listChart.append(item)
            
            // Reload the table view to update the UI
            tableView.reloadData()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    // Implement the MiddleCellDelegate method to handle navigation
    func didSelectItem(_ item: ItemModel) {
        let vc = DetailsViewController()
        vc.data = item
        navigationController?.pushViewController(vc, animated: true)
    }
}




