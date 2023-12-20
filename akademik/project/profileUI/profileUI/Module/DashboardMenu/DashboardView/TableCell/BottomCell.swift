//
//  BottomCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit
import RxSwift
import RxGesture

// MARK: - Protocol

protocol BottomCellDelegate: AnyObject {
    func didButtonTapped()
}


class BottomCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var manyItemLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    // MARK: - Properties
    
    weak var delegate: BottomCellDelegate?
    internal var totalPrice: Float = 0 {
        didSet {
            totalPriceLabel.text = totalPrice.toDollarFormat()
        }
    }
    internal var manyItem = 0 {
        didSet {
            manyItemLabel.text = "\(manyItem) Items"
        }
    }
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupEvent()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Protocol
    
    func setupUI() {
        selectionStyle = .none
    }
    
    // MARK: - Setup Event
    
    func setupEvent() {
        buttonView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.buttonViewTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func buttonViewTapped() {
        delegate?.didButtonTapped()
    }
}
