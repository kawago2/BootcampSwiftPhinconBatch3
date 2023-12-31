import UIKit

class InsightViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var differentLabel: UILabel!
    @IBOutlet weak var threadLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: InsightViewModel!
    private let vsLastWeekString = " vs last week"
    private let percentageValue = 4.3
    private let recentUpdate = ["Brees", "Paystack", "Piggyvest"]
    private let viewedUpdate = ["Carbon", "Abeg", "Patricia"]
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = InsightViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPopUp(titleButton: "View Insights", image: CustomImage.imageInsightPop, getDefaultManager: UserDefaultsManager.shared.getFirstInsight(), setDefaultManager: {
            UserDefaultsManager.shared.setFirstInsight(false)
        })
    }
    

    
    // MARK: - UI Setup
    private func setupUI() {
        topView.roundCorners(corners: [.allCorners], cornerRadius: 30)
        cardView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 20)
        navigationBar.centerLabel.textColor = .white
        navigationBar.titleNavigationBar = viewModel.titleNavigationBar
        threadLabel.textColor = .white.withAlphaComponent(0.70)
        
        tableView.registerCellWithNib(InsightCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setupLabel()
        
    }
    
    private func setupLabel() {
        let percentageString = String(format: "+%.1f%%", percentageValue)
        let percentageAttributedString = viewModel.makeAttributedString(with: percentageString, color: .green)
        let vsLastWeekAttributedString = viewModel.makeAttributedString(with: vsLastWeekString, color: .white)

        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(percentageAttributedString)
        combinedAttributedString.append(vsLastWeekAttributedString)

        differentLabel.attributedText = combinedAttributedString
    }
    
}

// MARK: - TableView Delegate and DataSource
extension InsightViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsightCell", for: indexPath) as! InsightCell
        switch indexPath.section {
        case 0:
            cell.setTitle(title: recentUpdate[indexPath.row])
        case 1:
            cell.setTitle(title: viewedUpdate[indexPath.row])
        default:
            break
        }
        cell.passData(index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        let label = UILabel()
        label.textColor = UIColor(named: ColorName.sixColor)
        label.font = UIFont(name: FontName.medium, size: 14)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)

        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: headerView.topAnchor, constant: 0)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recent updates"
        case 1:
            return "Viewed updates"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showFullStory(at: indexPath.row)
    }
    
    private func showFullStory(at index: Int) {
        let vc = StoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Setup PopUp
extension InsightViewController: CustomPopUpViewDelegate {
    func showPopUp(titleButton: String, image: String, getDefaultManager: Bool, setDefaultManager: @escaping () -> Void) {
        guard getDefaultManager else {
            return
        }

        let vc = CustomPopUpViewController()
        vc.configurePopUp(item: CustomPopUp(image: image, titleButton: titleButton))
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true) {
            setDefaultManager()
        }
    }
    func buttonLogic() {
        
    }
    
    func setCustomData(data: CustomPopUp) {
        
    }
    
    
}
