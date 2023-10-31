import UIKit

class ToolCell: UITableViewCell {
    
    
    @IBOutlet weak var collView: UICollectionView!
    
    
    
    var cellData: [String] = ["banner1", "banner2", "banner3"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        configureCell()
    }
    
    
    func configureCell() {
        collView.delegate = self
        collView.dataSource = self
        collView.registerCellWithNib(BannerCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let padding: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        collView.setCollectionViewLayout(layout, animated: true)
    }
}




extension ToolCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as BannerCell
        cell.delegate = self
        cell.configureData(data: cellData[index])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the size for each cell
        let gridWidth = collectionView.bounds.width
        let itemWidth = gridWidth
        return CGSize(width: itemWidth, height: 200)
    }
}


extension ToolCell: BannerCellDelegate {
    // Implement the delegate method
    func didTapDetailsButton(in cell: BannerCell) {
        if let indexPath = collView.indexPath(for: cell) {
            let index = indexPath.row
            if let navigationController = window?.rootViewController as? UINavigationController {
                let vc = DetailsViewController()
                vc.image = cellData[index]
                vc.pageTitle = "Banner"
                navigationController.pushViewController(vc, animated: true)
            }
        }

    }
}
