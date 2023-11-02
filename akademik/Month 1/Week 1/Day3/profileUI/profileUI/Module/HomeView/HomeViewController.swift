//
//  HomeViewController.swift
//  profileUI
//
//  Created by Phincon on 31/10/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
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
        tableView.registerCellWithNib(TopCell.self)
        tableView.registerCellWithNib(MiddleCell.self)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
            cell.listFood = listFood
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
            let itemHeight: CGFloat = 280
            let itemsPerRow: Int = 2
            let rowCount = (listFood.count + 1) / itemsPerRow
            let totalHeight = CGFloat(rowCount) * itemHeight
            return totalHeight
        default:
            return 0
        }
    }
    

}


