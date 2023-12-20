//
//  ChartCell.swift
//  profileUI
//
//  Created by Phincon on 07/11/23.
//

import UIKit
import RxSwift

// MARK: - Protocol

protocol CartCellDelegate: AnyObject{
    func didMinusTapped(_ item: ItemModel)
    func didPlusTapped(_ item:  ItemModel)
    func didTashTapped(_ item:  ItemModel)
}

class CartCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageeView: UIImageView!
    
    // MARK: - Properties
    
    weak var delegate: CartCellDelegate?
    internal var item: ItemModel? {
        didSet {
            loadData()
        }
    }
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupEvent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Load Data
    
    func loadData() {
        namaLabel.text = item?.name ?? ""
        qtyLabel.text = "\(item?.quantity ?? 0)"
        priceLabel.text = item?.price?.toDollarFormat()
        let image = item?.image ?? "image_not_available"
        imageeView.image = UIImage(named: image)
    }
    
    // MARK: - Setup Event
    
    func setupEvent() {
        minusButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.minusTapped()
        }).disposed(by: disposeBag)
        
        plusButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.plusTapped()
        }).disposed(by: disposeBag)
        
        deleteButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.trashTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func minusTapped() {
        if let item = item {
            delegate?.didMinusTapped(item)
        }
    }

    private func plusTapped() {
        if let item = item {
            delegate?.didPlusTapped(item)
        }
    }
    
    private func trashTapped() {
        if let item = item {
            delegate?.didTashTapped(item)
        }
    }
}
