//
//  BottomCell.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import UIKit

protocol MiddleCellDelegate {
    func didSelectItem(_ item: ItemModel)
    func didTapAddButton(_ item: ItemModel)
}

class MiddleCell: UITableViewCell, FoodCellDelegate {
    func didTapAddButton(_ item: ItemModel) {
        self.delegate?.didTapAddButton(item)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var listFood: [ItemModel] = []
    
    var delegate: MiddleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setup()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup() {
        configureCell()
    }
    

    func configureCell() {
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
    
}



extension MiddleCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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


