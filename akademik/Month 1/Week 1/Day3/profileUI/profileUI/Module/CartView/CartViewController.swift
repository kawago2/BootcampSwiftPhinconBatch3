//
//  ChartViewController.swift
//  profileUI
//
//  Created by Phincon on 03/11/23.
//

import UIKit
import CoreData
import FloatingPanel


protocol CartViewDelegate {
    func passData(listChart: [ItemModel])
}

class CartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
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
    
    @objc func payButtonTapped() {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.surfaceView.backgroundColor = .white
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.contentMode = .fitToBounds
        let vc = FloatingPanelView()
        fpc.set(contentViewController: vc)
        // Disable dragging
        fpc.isRemovalInteractionEnabled = false
        
        // Set the height of the panel content
        vc.view.layoutIfNeeded() // Ensure the view has been laid out
        
        present(fpc, animated: true, completion: nil)
    }
    
    func setup() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        payButton.setRoundedBorder(cornerRadius: 20)
        
        if listChart.isEmpty {
            payButton.isHidden = true
        }
        
        
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
                    spreadCart.append(ItemModel(id: item.id, image: item.image,name: item.name ,price: item.price,quantity: 1))
                }
            } else {
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

extension CartViewController: FloatingPanelControllerDelegate {
    
}


