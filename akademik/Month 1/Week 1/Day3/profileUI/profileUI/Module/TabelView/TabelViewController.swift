//
//  TabelViewViewController.swift
//  profileUI
//
//  Created by Phincon on 26/10/23.
//
import Foundation
import UIKit

class TabelViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var listMakanan: [ModelItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    func setup() {
        configureTable()
    }
    
    func loadData() {
        listMakanan.append(ModelItem())
        listMakanan.append(ModelItem(nama: "Ayam Geprek", harga: 20000, img: "ayam_geprek"))
        listMakanan.append(ModelItem(nama: "Ikan Gurame", harga: 25000))
        listMakanan.append(ModelItem(nama: "Pecel Lele", harga: 25000, img: "pecel_lele"))
    }
    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(FoodCell.self)
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

extension TabelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMakanan.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        let makanan = listMakanan[index]
        cell.configureData(data: makanan)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let makanan = listMakanan[index]
        let vc = DetailsViewController()
        vc.data = makanan
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}
