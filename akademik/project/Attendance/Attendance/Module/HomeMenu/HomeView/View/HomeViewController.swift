import UIKit
import RxSwift
import RxCocoa
import RxGesture

class HomeViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var formView: UIImageView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isCheckInLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var circleButton: UIView!
    @IBOutlet weak var validatorView: UIImageView!
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupEvent()
        setupRealTimeClock()
        setDefaultSelected()
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup ViewModel
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        circleButton.layer.cornerRadius = circleButton.bounds.width / 2.0
        circleButton.clipsToBounds = true
        circleView.tintColor = .white.withAlphaComponent(0.05)
        checkView.makeCornerRadius(20)
        updateCheck()
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        viewModel.isCheckIn.subscribe(onNext: {[weak self] result in
            guard let self = self else { return }
            self.logicCheck(is: result)
        }).disposed(by: disposeBag)
        
        isCheckInLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self]_ in
            guard let self = self else { return }
            self.viewModel.checkToggle()
        }).disposed(by: disposeBag)
        
        formView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self]_ in
            guard let self = self else { return }
            self.navigateToForm()
        }).disposed(by: disposeBag)
        
        validatorView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self]_ in
            guard let self = self else { return }
            self.navigateToValidator()
        }).disposed(by: disposeBag)
    }
    
    private func logicCheck(is isCheckIn: Bool) {
        updateCheck()
        tableView.reloadData()
        if isCheckIn == false {
            setDefaultSelected()
        }
        addToFirebase()
    }
    

    
    
    private func addToFirebase() {
        viewModel.addDataToFirebase {result in
            switch result {
            case .success():
                ()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
    }
    
    // MARK: - Fetch Data
    
    private func fetchData() {
        showLoading()
        viewModel.getData {result in
            self.hideLoading()
            switch result {
            case .success():
                self.updateCheck()
                self.setDefaultSelected()
                if self.viewModel.isCheckIn.value == true {
                    self.tableView.reloadData()
                }
                self.validatorView.isHidden = !self.viewModel.isValidator
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Update UI
    
    private func updateCheck() {
        isCheckInLabel.text = viewModel.isCheckIn.value ? "CHECK OUT" : "CHECK IN"
        circleButton.backgroundColor = viewModel.isCheckIn.value ? UIColor.systemOrange : UIColor.systemGreen
    }

    private func setDefaultSelected() {
        let defaultIndexPath = IndexPath(row: self.viewModel.selectedCell, section: 0)
        tableView.selectRow(at: defaultIndexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: defaultIndexPath)
    }
    
    // MARK: - Navigation
    
    private func navigateToForm() {
        let vc = PermissionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToValidator() {
        let vc = ApproveViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    private func setupRealTimeClock() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.updateTimeLabels()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateTimeLabels() {
        viewModel.currentDate = Date()

        let formattedDate = viewModel.currentDate.formattedFullDateString()
        let formattedTime = viewModel.currentDate.formattedFullTimeString()

        dateLabel.text = "\(formattedDate)"
        clockLabel.text = "Hour: \(formattedTime)\n"
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    private func configureTable() {
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isCheckIn.value ? 1 : viewModel.locationArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let isCheckIn = viewModel.isCheckIn.value
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let location = isCheckIn ? viewModel.locationSelected : viewModel.locationArray[index]
        if isCheckIn {
            let defaultIndexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: defaultIndexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: defaultIndexPath)
        }
        cell.context = isCheckIn ? true : false
        cell.isUseSelected = true
        if let location = location {
            cell.initData(item: location)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isCheckIn.value == false {
            let index = indexPath.row
            self.viewModel.selectedCell = index
            let locationSelected = viewModel.locationArray[index]
            self.viewModel.locationSelected = locationSelected
        }
    }
}
