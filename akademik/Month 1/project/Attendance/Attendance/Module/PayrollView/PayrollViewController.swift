import UIKit
import RxSwift
import RxGesture

class PayrollViewController: UIViewController {

    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    
    func buttonEvent() {
        backButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.backTapped()
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        cardView.makeCornerRadius(20)
        circleView.tintColor = .white.withAlphaComponent(0.05)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(PayrollCell.self)
        tableView.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .bottom)
        tableView.allowsMultipleSelection = false
    }
    
    func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension PayrollViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayrollCell", for: indexPath) as? PayrollCell
        guard let cell = cell else { return  UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row, "deselect")
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row, "select")
        
    }
}
