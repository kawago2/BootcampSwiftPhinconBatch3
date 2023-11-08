//
//  ChartViewController.swift
//  profileUI
//
//  Created by Phincon on 03/11/23.
//

import UIKit
import CoreData

protocol CartViewDelegate {
    func passData(listChart: [ItemModel])
}

class CartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    var listChart: [ItemModel] = []
    var uniqueCart: [ItemModel] = []
    var sum: Float = 0
    
    var delegate: CartViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTable()
        setupData()
        setup()
        totalPrice()
    }
    
    @objc func backButtonTapped(_ sender: Any) {
        delegate?.passData(listChart: uniqueCart)
        navigationController?.popViewController(animated: true)
    }
    
    func setup() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    func setupUI() {
        
    }
    
    func setupData() {
        combineItemsInCart()
    }
    
    func combineItemsInCart() {
        var combinedCart: [UUID: ItemModel] = [:]

        for item in listChart {
            if var existingItem = combinedCart[item.id] {
                // You need to update the quantity of the existing item in combinedCart
                existingItem.quantity += 1
                combinedCart[item.id] = existingItem
            } else {
                combinedCart[item.id] = item
            }
        }
        listChart = Array(combinedCart.values)
    }
    
    func spreadItemChart() {
        uniqueCart = []

        var spreadCart: [ItemModel] = []

        for item in listChart {
            if item.quantity > 1 {
                for _ in 1...item.quantity {
                    // Create a new item for each quantity and add it to the spreadCart
                    spreadCart.append(ItemModel(id: item.id, image: item.image,name: item.name ,price: item.price,quantity: 1))
                }
            } else {
                // If quantity is 1, just add the item as is
                spreadCart.append(item)
            }
        }

        uniqueCart = spreadCart
    }

    
    func totalPrice() {
        sum = 0
        for item in listChart {
            let totalPerItem = (item.price ?? 0) * Float(item.quantity)
            sum += totalPerItem
        }
        totalLabel.text = "Total: \(sum.toDollarFormat())"
    }
    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(CartCell.self)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.item = listChart[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
}


extension CartViewController: CartCellDelegate {
    func didTashTapped(_ item: ItemModel) {
        if let index = listChart.firstIndex(where: { $0.id == item.id }) {
            // Found the item with the same ID in listChart, remove it
            listChart.remove(at: index)
            tableView.reloadData()
            // Update your total price here
            totalPrice()
            spreadItemChart()
        }
    }
    
    func didMinusTapped(_ item: ItemModel) {
        if let index = listChart.firstIndex(where: { $0.id == item.id }) {
            // Found the item with the same ID in listChart
            if listChart[index].quantity > 0 {
                listChart[index].quantity -= 1
                tableView.reloadData()
                // Update your total price here
                totalPrice()
                spreadItemChart()
            }
        }
    }
    
    func didPlusTapped(_ item: ItemModel) {
        if let index = listChart.firstIndex(where: { $0.id == item.id }) {
            // Found the item with the same ID in listChart
            listChart[index].quantity += 1
            tableView.reloadData()
            // Update your total price here
            totalPrice()
            spreadItemChart()
        }
    }

}
