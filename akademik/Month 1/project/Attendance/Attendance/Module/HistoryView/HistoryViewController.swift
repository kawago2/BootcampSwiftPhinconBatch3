import UIKit
import RxSwift
import RxGesture
import FirebaseFirestore

class HistoryViewController: UIViewController {
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var loadingView: CustomLoading!
    @IBOutlet weak var emptyView: CustomEmpty!
    
    let scrollToTopButton = UIButton(type: .system)
    
    
    var allData: [InfoItem] = []
    var allDataHistory: [HistoryItem] = []
    var filteredData: [HistoryItem] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        setupScrollToTopButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dayButtonTapped()
    }
    
    func buttonEvent() {
        dayButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.dayButtonTapped()
        }).disposed(by: disposeBag)
        
        weekButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.weekButtonTapped()
        }).disposed(by: disposeBag)
        
        monthButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.monthButtonTapped()
        }).disposed(by: disposeBag)
        
        yearButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.yearButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    @objc func dayButtonTapped() {
        fetchData() {
            self.filterData(by: .day)
        }
        dayButton.isSelected = true
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = false
    }

    @objc func weekButtonTapped() {
        fetchData() {
            self.filterData(by: .weekOfYear)
        }
        dayButton.isSelected = false
        weekButton.isSelected = true
        monthButton.isSelected = false
        yearButton.isSelected = false
    }

    @objc func monthButtonTapped() {
        fetchData() {
            self.filterData(by: .month)
        }
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = true
        yearButton.isSelected = false
        
    }

    @objc func yearButtonTapped() {
        fetchData() {
            self.filterData(by: .year)
        }
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = true
    }
    
    func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.05)
        bottomView.makeCornerRadius(20)
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupScrollToTopButton() {
        scrollToTopButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        scrollToTopButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.goToTopButtonTapped()
        }).disposed(by: disposeBag)
        
        scrollToTopButton.translatesAutoresizingMaskIntoConstraints = false
        scrollToTopButton.isHidden = true
        view.addSubview(scrollToTopButton)

        scrollToTopButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-100)
        }
        
    }
    
    @objc func goToTopButtonTapped() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func fetchData(completion: @escaping () -> Void?) {
        loadingView.startAnimating()
        allData = []
        allDataHistory = []
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "history"
        
        FFirestore.getDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath) { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    if let data = document.data() {
                        let date = data["checkTime"] as? Timestamp
                        let isCheck = data["isCheck"] as? Bool ?? false
                        let title = data["titleLocation"] as? String ?? "DefaultTitle"
                        let description = data["descLocation"] as? String ?? "DefaultDescription"
                        let imageName = data["image"] as? String ?? "DefaultImage"
                        
                        let checkString = isCheck ? "Check In" : "Check Out"
                        
                        let formattedTime = date?.dateValue().formattedFullDateString() ?? Date().formattedFullDateString()


                        let infoItem = InfoItem(title: "\(checkString) - \(title) - \(formattedTime)", description: description, imageName: imageName)
                        let historyItem = HistoryItem(checkTime: date?.dateValue(), descLocation: description, image: imageName, isCheck: isCheck, titleLocation: title)
                        
                        
                        self.allData.append(infoItem)
                        self.allDataHistory.append(historyItem)
                    }
                }
                self.tableView.reloadData()
                self.loadingView.stopAnimating()
                
                
                completion()
            case .failure(let error):
                print("Error getting data from subcollection: \(error.localizedDescription)")
            }
        }
    }

    
    func filterData(by component: Calendar.Component) {
        var setCalendar = Calendar.current
        setCalendar.timeZone = .gmt
        let calendar = setCalendar
        let currentDate = Date()

        var startDate: Date
        var endDate: Date

        switch component {
        case .day:
            startDate = calendar.startOfDay(for: currentDate)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate) ?? currentDate
        case .weekOfYear:
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
                return
            }
            startDate = startOfWeek
            endDate = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? currentDate
        case .month:
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
                return
            }
            startDate = startOfMonth
            endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? currentDate
        case .year:
            guard let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: currentDate)) else {
                return
            }
            startDate = startOfYear
            endDate = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear) ?? currentDate
        default:
            return
        }
        filteredData = allDataHistory.filter { item in
            if let checkTime = item.checkTime {
                let checker = checkTime >= startDate && checkTime <= endDate
                return checker
            }
            return false
        }
        if filteredData.isEmpty {
            emptyView.show()
            
        } else {
            emptyView.hide()
        }
        tableView.reloadData()
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func deleteRow(at indexPath: IndexPath) {
        let deletedItem = filteredData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)

        print("Deleted item: \(deletedItem)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.isEmpty {
            return 0
        }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        if allData.isEmpty {
            return cell
        } else {
            if filteredData.isEmpty {
                return cell
            } else {
                let filter = filteredData[index]
                
                let checkString = filter.isCheck ?? false ? "Check In" : "Check Out"
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm a"
                let formattedTime = timeFormatter.string(from: filter.checkTime ?? Date())
                let title = filter.titleLocation ?? ""
                
                cell.initData(title: "\(checkString) - \(title) - \(formattedTime)", desc: filter.descLocation ?? "", img: filter.image ?? "image_not_available")
                return cell
            }
           
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if filteredData.isEmpty {return}
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offset >= contentHeight - screenHeight {
            scrollToTopButton.isHidden = false
        } else {
            scrollToTopButton.isHidden = true
        }
    }
}
