//
//  FoodCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Protocol

protocol FoodCellDelegate: AnyObject {
    func didTapAddButton(_ item: ItemModel)
}

class FoodCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addChartButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: FoodCellDelegate?
    private var isFavorited = false
    internal var item: ItemModel? {
        didSet {
            configureCell()
        }
    }
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        configureCell()
        buttonEvent()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        outerView.layer.borderWidth = 1
        outerView.layer.cornerRadius = 20
        outerView.layer.borderColor = UIColor(named: "ProColor")?.cgColor
        imageView.setCircleNoBorder()
    }
    
   private func configureCell() {
        if let item = item {
            let image = item.image ?? "image_not_available"
            let name = item.name ?? "---"
            let price = item.price ?? 0
            let isFavorite = item.isFavorite ?? false
            
            imageView.image = UIImage(named: image)
            nameLabel.text = name
            priceLabel.text = price.toDollarFormat()
            isFavorited = isFavorite
            favoriteButton.tintColor = isFavorite ? UIColor.red : UIColor(named: "ProColor")
        }
    }
    
    // MARK: - Setup Event
    
   private func buttonEvent() {
       
       favoriteButton.rx.tap.subscribe(onNext: {[weak self] in
           guard let self =  self else {return}
           self.favoriteTapped()
       }).disposed(by: disposeBag)
       
       addChartButton.rx.tap.subscribe(onNext: {[weak self] in
           guard let self =  self else {return}
           self.addTapped()
       }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func favoriteTapped() {
        isFavorited = !isFavorited
        if isFavorited {
            favoriteButton.tintColor = UIColor.red
        } else {
            favoriteButton.tintColor = UIColor(named: "ProColor")
        }
    }
    
    private func addTapped() {
        delegate?.didTapAddButton(item ?? ItemModel())
    }
}
