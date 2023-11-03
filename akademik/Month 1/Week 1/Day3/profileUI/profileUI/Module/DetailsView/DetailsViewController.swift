//
//  DetailsViewController.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//
import Foundation
import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // declarate
    var data: ItemModel?
    var image: String?
    var isFavorited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        loadData()
        configureUI()
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    func configureUI() {
        topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
    }
    
    func loadData() {
        if let validFood = data {
            namaLabel.text = validFood.name ?? "Not Found"
            priceLabel.text = validFood.price?.toDollarFormat() ?? 0.toDollarFormat()
            var isFavorite = validFood.isFavorite ?? false
            isFavorited = isFavorite
            favoriteButton.tintColor = isFavorite ? UIColor.red : UIColor(named: "ProColor")
            if let image = UIImage(named: validFood.image ?? "image_not_available") {
                self.imgView.image = image
            }
        }
    }
    
    @objc func favoriteTapped() {
        isFavorited = !isFavorited
        if isFavorited {
            favoriteButton.tintColor = UIColor.red
        } else {
            favoriteButton.tintColor = UIColor(named: "ProColor")
        }
    }
}
