import UIKit
import RxSwift


class NotificationViewController: BaseViewController {
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = NotificationViewModel()
    private var isTransactionAlert = false
    private var isInsightAlert = false
    private var isSortTransactionsAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialData()
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = viewModel.titleNavigationBar
        navigationBar.setupLeadingButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.registerCellWithNib(NotificationCell.self)
        
    }
    
    private func setupEvent() {
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backToView()
        }).disposed(by: disposeBag)
    }
    
    private func initialData() {
        isTransactionAlert = UserDefaultsManager.shared.getTransactionAlert()
        isInsightAlert = UserDefaultsManager.shared.getInsightAlert()
        isSortTransactionsAlert = UserDefaultsManager.shared.getSortTransactionsAlert()
        print(isTransactionAlert)
        print(isInsightAlert)
        print(isSortTransactionsAlert)

    }
}


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        switch indexPath.row {
        case 0:
            cell.setupConfigure(name: "Transaction alert", index: indexPath.row , isOn: self.isTransactionAlert)
        case 1:
            cell.setupConfigure(name: "Insight alert", index: indexPath.row , isOn: self.isInsightAlert)
        case 2:
            cell.setupConfigure(name: "Sort Transactions alert", index: indexPath.row, isOn: self.isSortTransactionsAlert )
        default:
            break
        }
        cell.delegate = self
        return cell
    }
}

extension NotificationViewController: NotificationCellDelegate {
    func switchValueChanged(isOn: Bool, index: Int) {
        switch index {
        case 0:
            self.viewModel.switchTransactionTapped(isOn: isOn)
        case 1:
            self.viewModel.switchInsightTapped(isOn: isOn)
        case 2:
            self.viewModel.switchSortTransactionsTapped(isOn: isOn)
        default:
            break
        }
    }
    
    
}
