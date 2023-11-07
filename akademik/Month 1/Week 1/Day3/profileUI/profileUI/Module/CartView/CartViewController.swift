//
//  ChartViewController.swift
//  profileUI
//
//  Created by Phincon on 03/11/23.
//

import UIKit
import CoreData

class CartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    var listChart: [ItemModel] = []
    
    var itemCounts = [ItemModel: Int]()
    
    var mergedListChart: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTable()
        fetchCoreData()
        setupData()
        setup()
    }
    
    @objc func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setup() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    func setupUI() {
        
    }
    
    func setupData() {
        for item in listChart {
            if let count = itemCounts[item] {
                itemCounts[item] = count + 1
            } else {
                itemCounts[item] = 1
            }
        }

        for (item, count) in itemCounts {
            mergedListChart.append(ItemModel(name: (item.name ?? "") + " (\(count))"))
        }
    }
    

    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ChartCell.self)
    }
    
    
    func fetchCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // Create a fetch request for the "Foods" entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")

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
                        listChart.append(item)
                    }
                }
            }
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }

    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mergedListChart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
        cell.configureData(name: mergedListChart[index].name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

}
