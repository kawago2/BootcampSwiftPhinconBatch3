import UIKit
import RxSwift
import RxCocoa
import RxGesture

class HomeViewController: UIViewController {
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var formView: UIImageView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isCheckInLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var circleButton: UIView!
    @IBOutlet weak var validatorView: UIImageView!
    
    
    let locationArray: [InfoItem] = [
        InfoItem(title: "PT. Phincon", description: "Office. 88 @Kasablanka Office Tower 18th Floor", imageName: "id_1"),
        InfoItem(title: "Telkomsel Smart Office", description: "Jl. Jend. Gatot Subroto Kav. 52. Jakarta Selatan", imageName: "id_2"),
        InfoItem(title: "Rumah", description: "Jakarta", imageName: "id_3")
    ]
    
    var locationSelected: InfoItem?
    var isCheckIn = false
    var timer: Timer?
    var selectedCell = 0
    var currentDate = Date()
    var isValidator = false
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
        setupRealTimeClock()
        setDefaultSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentData()
    }
    
    func buttonEvent() {
        isCheckInLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self]_ in
            guard let self = self else { return }
            self.checkToggle()
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

    @objc func checkToggle() {
        self.isCheckIn = !isCheckIn
        updateCheck()
        tableView.reloadData()
        if isCheckIn == false {
            setDefaultSelected()
        }
        addToFirebase()
    }
    
    @objc func navigateToForm() {
        let vc = PermissionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToValidator() {
        let vc = ApproveViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func addToFirebase() {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        let check = isCheckIn
        let currentCell = self.selectedCell
        let collection =  "users"
        let documentID = uid
        
        let dataToSet: [String: Any] = [
            "is_check": check as Bool,
            "uid": uid as String,
            "active_page": currentCell as Int,
        ]

        FFirestore.editDocument(inCollection: collection, documentIDToEdit: documentID, newData: dataToSet) { result in
            switch result {
            case .success:
                print("Document set successfully")
            case .failure(let error):
                print("Error setting document: \(error.localizedDescription)")
            }
        }
        
       
        let subcollectionPath = "history"
        let dataToAdd: [String: Any] = [
            "checkTime": self.currentDate ,
            "descLocation": locationArray[currentCell].description ?? "",
            "titleLocation": locationArray[currentCell].title ?? "",
            "image": locationArray[currentCell].imageName ?? "",
            "isCheck": self.isCheckIn,
        ]

        FFirestore.addDataToSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath, data: dataToAdd) { result in
            switch result {
            case .success:
                print("Data added to subcollection successfully")
            case .failure(let error):
                print("Error adding data to subcollection: \(error.localizedDescription)")
            }
        }

    }

    func setupUI() {
        circleButton.layer.cornerRadius = circleButton.bounds.width / 2.0
        circleButton.clipsToBounds = true
        circleView.tintColor = .white.withAlphaComponent(0.05)
        checkView.makeCornerRadius(20)
        updateCheck()
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func updateCheck() {
        isCheckInLabel.text = isCheckIn ? "CHECK OUT" : "CHECK IN"
        circleButton.backgroundColor = isCheckIn ? UIColor.systemOrange : UIColor.systemGreen
    }


    func setupRealTimeClock() {
        updateTimeLabels()

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabels), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeLabels() {
        self.currentDate = Date()
        
        let formattedDate = currentDate.formattedFullDateString()
        let formattedTime = currentDate.formattedFullTimeString()


        dateLabel.text = "\(formattedDate)"
        clockLabel.text = "Hour: \(formattedTime)\n"
    }
    
    func setDefaultSelected() {
        let defaultIndexPath = IndexPath(row: self.selectedCell, section: 0)
        tableView.selectRow(at: defaultIndexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: defaultIndexPath)
    }
    
    func getCurrentData() {
        guard let uid = FAuth.auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let documentID = uid
        let collection = "users"
        
        FFirestore.getDocument(collection: collection,documentID: documentID) { result in
            switch result {
            case .success(let documentSnapshot):
                let data = documentSnapshot.data()
                if let currentData = data {
                    if let isCheckIn = currentData["is_check"] as? Bool,
                       let activePage = currentData["active_page"] as? Int{
                        // Check if "isValidator" exists in the document data
                        if let isValidator = currentData["isValidator"] as? Bool {
                            self.isValidator = isValidator
                        } else {
                            // Default value if "isValidator" is not present
                            self.isValidator = false
                        }
                        self.isCheckIn = isCheckIn
                        self.selectedCell = activePage
                        self.locationSelected = self.locationArray[activePage]
                        self.updateCheck()
                        self.setDefaultSelected()
                        if isCheckIn == true {
                            
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Error: Unable to parse document data")
                    }
                }
            self.validatorView.isHidden = !self.isValidator
            case .failure(let error):
                print("Error getting document: \(error.localizedDescription)")
            }
        }
        
       
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCheckIn ? 1 : locationArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let location = isCheckIn ? locationSelected : locationArray[index]
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
        if isCheckIn == false {
            let index = indexPath.row
            self.selectedCell = index
            let locationSelected = locationArray[index]
            self.locationSelected = locationSelected
        }

    }
}
