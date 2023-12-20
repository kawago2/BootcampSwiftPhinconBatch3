//
//  DetailsViewController.swift
//  profileUI
//
//  Created by Phincon on 27/10/23.
//
import UIKit
import RxGesture

class DetailsViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Properties
    internal var viewModel: DetailsViewModel!
    private var data: ItemModel?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        buttonEvent()
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
        buttonView.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    // MARK: - Setup Event
    
   private func buttonEvent() {
       favoriteButton.rx.tap.subscribe(onNext: {[weak self] in
           guard let self = self else { return }
           self.favoriteTapped()
       }).disposed(by: disposeBag)
       
       backButton.rx.tap.subscribe(onNext: {[weak self] in
           guard let self = self else { return }
           self.backToView()
       }).disposed(by: disposeBag)
    }
    
    // MARK: - Load Data
    
   private func loadData() {
        namaLabel.text = viewModel?.name
        priceLabel.text = viewModel?.price
        imgView.image = viewModel?.image
        favoriteButton.tintColor = viewModel.isFavorited ? UIColor.red : UIColor(named: "ProColor")
    }
    
    // MARK: - Action Handling
    
    private func favoriteTapped() {
        viewModel?.toggleFavorite()
        favoriteButton.tintColor = viewModel.isFavorited ? UIColor.red : UIColor(named: "ProColor")
    }
}
