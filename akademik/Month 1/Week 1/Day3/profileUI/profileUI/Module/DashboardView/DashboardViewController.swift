import UIKit

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var listFood: [ItemModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureTable()
        loadData()
    }
    
    func setup() {
        
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


extension DashboardViewController: UITableViewDelegate, UITableViewDataSource, MiddleCellDelegate {
    // Implement the MiddleCellDelegate method to handle navigation
    func didSelectItem(_ item: ItemModel) {
        let vc = DetailsViewController()
        vc.data = item
        navigationController?.pushViewController(vc, animated: true)
    }
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


