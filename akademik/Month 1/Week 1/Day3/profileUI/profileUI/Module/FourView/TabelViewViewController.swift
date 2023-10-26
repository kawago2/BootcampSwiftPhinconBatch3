//
//  TabelViewViewController.swift
//  profileUI
//
//  Created by Phincon on 26/10/23.
//
import Foundation
import UIKit

class TabelViewViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // Data lokasi
    let listMakanan = [
        ["nama": "Ayam Geprek", "harga": 20000, "img": "ayam_geprek"],
        ["nama": "Ikan Gurame", "harga": 25000, "img": "ikan_gurame"],
        ["nama": "Pecel Lele", "harga": 25000, "img": "pecel_lele"]
    ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        configureTable()
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

extension TabelViewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMakanan.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell

        let makanan = listMakanan[indexPath.row]
        if let nama = makanan["nama"], let harga = makanan["harga"], let image = makanan["img"] {
            cell.namaMakananLabel.text = "\(nama)"
            cell.hargaMakananLabel.text = "Rp.\(harga)"
            let imgMakanan = cell.imgMakanan
            if let image = UIImage(named: "\(image)") {
                imgMakanan?.image = image
            }
            
        }
        return cell
    }
    
}
