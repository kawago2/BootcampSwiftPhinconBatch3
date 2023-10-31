//
//  DetailsViewController.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//
import Foundation
import UIKit

class DetailsViewController: UIViewController {
    var titlePage: String?
    
    var data: ModelItem?
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    var image: String?
    
    @IBOutlet weak var containerBottom: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var hargaLabel: UILabel!
    @IBOutlet weak var descView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNavTitle(title: titlePage ?? "")
    }
    func setup() {
        loadData()
        containerBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    func loadData() {
        if let validFood = data {
            namaLabel.text = validFood.nama ?? "Nama Tidak Tersedia"
            hargaLabel.text = validFood.harga?.toRupiahFormat() ?? 0.toRupiahFormat()
            if let image = UIImage(named: validFood.img ?? "image_not_available") {
                self.imgView.image = image
            }
        }
        
        if let validImage = image {
            if let image = UIImage(named: validImage) {
                self.imgView.image = image
            }
        }
        
    }
}
