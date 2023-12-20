//
//  BottomCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit

// MARK: - Protocol

protocol MiddleCellDelegate: AnyObject {
    func didSelectItem(_ item: ItemModel)
    func didTapAddButton(_ item: ItemModel)
}

class MiddleCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    weak var delegate: MiddleCellDelegate?
    internal var listFood: [ItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup UI
    
   private func setupUI() {
        selectionStyle = .none
    }
}

// MARK: - Delegate Handling

extension MiddleCell: FoodCellDelegate {
    func didTapAddButton(_ item: ItemModel) {
        self.delegate?.didTapAddButton(item)
    }
}

// MARK: - Configure Collection

extension MiddleCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   private func configureCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellWithNib(FoodCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let padding: CGFloat = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.isScrollEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFood.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FoodCell
        cell.delegate = self
        cell.item = listFood[index]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let food = listFood[index]
        delegate?.didSelectItem(food)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the size for each cell
        let gridWidth = collectionView.bounds.width
        let itemWidth = (gridWidth / 2) - 20
        return CGSize(width: itemWidth, height: 220)
    }
}






