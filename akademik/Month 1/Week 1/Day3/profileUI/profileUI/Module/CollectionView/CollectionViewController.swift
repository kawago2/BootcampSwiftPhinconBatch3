import UIKit

class CollectionViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listMinuman: [ModelItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    func setup(){
        configureTable()
    }
    
    func loadData() {
        listMinuman.append(ModelItem(nama: "Es Teh", harga: 5000))
        listMinuman.append(ModelItem(nama: "Pink Lava", harga: 10000))
        listMinuman.append(ModelItem(nama: "Es Kelapa", harga: 6000))
        listMinuman.append(ModelItem(nama: "Es Susu Soda", harga: 5000))
        listMinuman.append(ModelItem(nama: "Es Matcha", harga: 10000))
        listMinuman.append(ModelItem(nama: "Es Kepal Milo", harga: 6000))
    }
    
    func configureTable() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellWithNib(DrinkCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}


extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMinuman.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DrinkCell
        let drinkItem = listMinuman[indexPath.row]
        cell.configureData(data: drinkItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the size for each cell
        let gridWidth = collectionView.bounds.width
        let itemWidth = gridWidth / 3.0
        return CGSize(width: itemWidth, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let minuman = listMinuman[index]
        let vc = DetailsViewController()
        vc.data = minuman
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
