import UIKit
import RxSwift
import RxGesture
import FirebaseFirestore

class PayrollViewController: UIViewController {

    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataPayroll: [Payroll] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
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
        tableView.allowsMultipleSelection = false
    }
    
    func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    let arraykosong = [1,2,3,4]
    
    
    func fetchData() {
        dataPayroll = []
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "payroll"
        
        FFirestore.getDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath) { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    if let data = document.data() {
                        let id = data["payrollId"] as? String
                        let basicSalary = data["basicSalary"] as? Float
                        let date = data["date"] as? Timestamp

                        // Mapping allowances
                        var allowances: [Allowance] = []
                        if let allowancesData = data["allowances"] as? [String: Any] {
                            allowances = allowancesData.compactMap { allowanceData in
                                guard let amount = allowanceData.value as? Float
                                else { return nil }
                                let name = allowanceData.key as String
                                return Allowance(name: name, amount: amount)
                            }
                        }

                        // Mapping deductions
                        var deductions: [Deduction] = []
                        if let deductionsData = data["deductions"] as? [String: Any] {
                            deductions = deductionsData.compactMap { deductionData in
                                guard let amount = deductionData.value as? Float
                                else { return nil }
                                let name = deductionData.key as String
                                return Deduction(name: name, amount: amount)
                            }
                        }

                        let netSalary = data["netSalary"] as? Float

                        let itemPayroll = Payroll(
                            payrollId: id ?? "",
                            date: date?.dateValue() ?? Date(),
                            basicSalary: basicSalary ?? 0.0,
                            allowances: allowances,
                            deductions: deductions,
                            netSalary: netSalary ?? 0.0
                        )

                        self.dataPayroll.append(itemPayroll)
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                print("Error getting data from subcollection: \(error.localizedDescription)")
            }
        }
    }
}

extension PayrollViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPayroll.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayrollCell", for: indexPath) as? PayrollCell
        guard let cell = cell else { return  UITableViewCell() }
        let item = dataPayroll[index]
        
        cell.initData(date: item.date.formattedShortDateString(), pay: item.netSalary.formatAsRupiah(), month: item.date.getMonth())
        
        switch index {
        case 0:
            cell.configuration(first: true, last: false)
        case dataPayroll.count - 1:
            cell.configuration(first: false, last: true)
        default:
            cell.configuration(first: false, last: false)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = DetailPayrollViewController()
        vc.initData(item: dataPayroll[index])
        navigationController?.pushViewController(vc, animated: true)
    }
}
