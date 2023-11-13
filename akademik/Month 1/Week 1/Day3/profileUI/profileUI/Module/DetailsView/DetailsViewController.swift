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
    @IBOutlet weak var buttonView: UIView!
    
    var viewModel: DetailsViewModel!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // declarate
    var data: ItemModel?
//    var image: String?
//    var isFavorited: Bool = false
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buttonEvent()
    }
    
    func setup() {
        loadData()
        configureUI()
    }
    
    func buttonEvent() {
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    func configureUI() {
        topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
        buttonView.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    func loadData() {
        namaLabel.text = viewModel?.name
        priceLabel.text = viewModel?.price
        imgView.image = viewModel?.image
        favoriteButton.tintColor = viewModel.isFavorited ? UIColor.red : UIColor(named: "ProColor")
    }
    
    @objc func favoriteTapped() {
        viewModel?.toggleFavorite()
        favoriteButton.tintColor = viewModel.isFavorited ? UIColor.red : UIColor(named: "ProColor")
    }
}
