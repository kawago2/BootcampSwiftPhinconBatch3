
import UIKit

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var listFood: [ItemModel] = []
    var listChart: [ItemModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureTable()
        loadData()
        loadListFoodFromUserDefaults()
    }
    
    func setup() {
        
    }
    
    func loadData() {
        listFood.append(ItemModel(image: "fish_curry", name: "Fish Curry", price: 10, isFavorite: true))
        listFood.append(ItemModel(image: "beef_pizza", name: "Beef Pizza", price: 15, isFavorite: false))
        listFood.append(ItemModel(image: "vagatale_salad", name: "Vagatale Salad", price: 5, isFavorite: false))
        listFood.append(ItemModel(image: "chicken_ball", name: "Chicken Ball", price: 25, isFavorite: true))
    }
    
    func loadListFoodFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "listChart"),
           let decodedlistChart = try? JSONDecoder().decode([ItemModel].self, from: savedData) {
            listChart = decodedlistChart
        }
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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCell", for: indexPath) as! MiddleCell
            cell.delegate = self
            cell.listFood = listFood
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BottomCell", for: indexPath) as! BottomCell
            var sum = 0
            if listChart.isEmpty == false {
                for list in listChart {
                    sum += list.price ?? 0
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
            let rowCount = (listFood.count + 1) / itemsPerRow
            let totalHeight = CGFloat(rowCount) * itemHeight
            return totalHeight
        case 2:
            return 64
        default:
            return 0
        }
    }
}

extension DashboardViewController : MiddleCellDelegate {
    func didTapAddButton(_ item: ItemModel) {
        if let existingData = LocalStorage.Base.data(forKey: "listChart") {
            do {
                var currentList = try JSONDecoder().decode([ItemModel].self, from: existingData)
                currentList.append(item)

                let updatedData = try JSONEncoder().encode(currentList)
                LocalStorage.Base.set(updatedData, forKey: "listChart")
                loadListFoodFromUserDefaults()
            } catch {
                print("Error decoding or encoding data: \(error)")
            }
        } else {
            do {
                let newData = [item]
                let encodedData = try JSONEncoder().encode(newData)
                LocalStorage.Base.set(encodedData, forKey: "listChart")
            } catch {
                print("Error encoding data: \(error)")
            }
        }

        LocalStorage.Base.synchronize() // Synchronize after the data changes, outside the do-catch block
        tableView.reloadData()
    }
    
    // Implement the MiddleCellDelegate method to handle navigation
    func didSelectItem(_ item: ItemModel) {
        let vc = DetailsViewController()
        vc.data = item
        navigationController?.pushViewController(vc, animated: true)
    }
}




