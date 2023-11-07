//
//  ChartViewController.swift
//  profileUI
//
//  Created by Phincon on 03/11/23.
//

import UIKit

class ChartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var listChart: [ItemModel] = []
    
    var itemCounts = [ItemModel: Int]()
    
    var mergedListChart: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTable()
        loadListFoodFromUserDefaults()
        setupData()
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
    
    func loadListFoodFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "listChart"),
           let decodedlistChart = try? JSONDecoder().decode([ItemModel].self, from: savedData) {
            listChart = decodedlistChart
        }
    }
    
}

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
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
