import UIKit
import RxSwift

class SettingViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigatorBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: SettingViewModel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingViewModel()
        setupUI()
        setupEvent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        navigatorBar.titleNavigationBar = viewModel.titleNavigationBar
        navigatorBar.setupLeadingButton()
        logoutButton.setRoundedBorder(cornerRadius: 30, borderWidth: 1,borderColor: .systemGray4)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(SettingCell.self)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    // MARK: - Event Handling
    private func setupEvent() {
        navigatorBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backToView()
        }).disposed(by: disposeBag)
        logoutButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.signOutTapped()
        }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Actions
    private func signOutTapped() {
        viewModel.signOut(completion: {result in
            switch result {
            case .success:
                self.setToLogin()
            case .failure(let err):
                print("Error signout: \(err)")
                self.showAlert(title: "Failed", message: "Failed to signout.")
            }
            
        })
    }
    
    private func setToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "General"
        case 1:
            return "Security"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        return (section == 1) ? 50 : 38
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        let label = UILabel()
        label.textColor = UIColor(named: "FourColor")
        label.font = UIFont(name: FontName.medium, size: 14)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)

        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        configureCell(for: cell, at: indexPath)
        return cell
    }

    func configureCell(for cell: SettingCell, at indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        
        guard let currentSection = section else {
            return
        }
        
        let row = indexPath.row
        
        switch currentSection {
        case .general:
            switch row {
            case 0:
                cell.setup(name: "Reset Password", description: nil)
            case 1:
                cell.setup(name: "Notifications", description: nil)
            default:
                break
            }
        case .security:
            cell.setup(name: "Privacy Policy", description: "Choose what data you share with us")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        
        guard let currentSection = section else {
            return
        }
        
        let row = indexPath.row
       
        switch currentSection {
        case .general:
            switch row {
            case 0:
                let vc = ResetPasswordViewController()
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = NotificationViewController()
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case .security:
            print("Privacy cliked")
        }
    }
}
