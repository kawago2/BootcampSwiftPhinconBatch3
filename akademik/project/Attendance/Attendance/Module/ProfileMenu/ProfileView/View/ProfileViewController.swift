import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture

class ProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var pencilButton: UIImageView!
    @IBOutlet weak var signoutButton: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var posisiLabel: UILabel!
    @IBOutlet weak var dollarButton: UIImageView!
    
    // MARK: - Properties
    
    private var viewModel: ProfileViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        buttonEvent()
        tableConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = ProfileViewModel()
    }
    
    
    // MARK: - Setup UI
    
    private func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.05)
        profileView.makeCornerRadius(20)
        profileImage.makeCornerRadius(20)
    }
    
    // MARK: - Button Event
    
    func buttonEvent() {
        signoutButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.signoutTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel.navigateToLogin.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.navigateToLogin()
        }).disposed(by: disposeBag)
        
        pencilButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigateFP()
            })
            .disposed(by: disposeBag)
        
        dollarButton.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigateToPayroll()
        }).disposed(by: disposeBag)
        
        viewModel.showAlert.subscribe(onNext: {[weak self] (title, message) in
            guard let self = self else { return }
            self.showAlert(title: title, message: message) {
                self.loadData()
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Load Data
    
    private func loadData() {
       showLoading()
        self.viewModel.loadDataGeneral(completionHandler: {[weak self] result in
            guard let self = self else { return }
            self.hideLoading()
            switch result {
            case .success():
                self.setupData()
            case .failure(_):
                self.hideLoading()
                self.showAlert(title: "Invalid", message: "Error Load Profile. Please try again.")
                self.profileImage.image = UIImage(named: Image.notAvail)
            }
        })
        
        self.viewModel.updateProfileImage.subscribe(onNext: { [weak self] url in
            guard let self = self else { return }
            self.profileImage.kf.setImage(with: url) {_ in 
                self.hideLoading()
            }
        }).disposed(by: disposeBag)
    }

    
    func setupData() {
        let profileData = viewModel.profileData
        self.nameLabel.text = profileData.name
        self.posisiLabel.text = profileData.posisi
        self.tableView.reloadData()
    }
    
    // MARK: - Setup Floating Panel
    
    func navigateFP() {
        let contentVC = EditProfileViewController()
        contentVC.delegate = self
        contentVC.setupViewModel(item: viewModel.profileData)
        let navController = UINavigationController(rootViewController: contentVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)
    }
    
    // MARK: - Action Handling
    
    func navigateToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func navigateToPayroll() {
        let vc = PayrollViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Configure Table View

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    private func tableConfigure() {
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profileArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "General"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font =  UIFont(name: "Avenir-Heavy", size: 15)
        header.textLabel?.textColor = UIColor(named: "PrimaryTextColor")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LocationCell
        let profile = viewModel.profileArray[index]
        cell.initData(item: profile)
        cell.context = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let menu = GeneralMenu(rawValue: index)
        switch menu {
        case .resetPassword:
            self.viewModel.resetPassword()
        default:
            break
        }
    }
}


extension ProfileViewController: EditProfileViewDelegate {
    func didSaveTapped(item: ProfileItem, image: UIImage?) {
        viewModel.editProfile(item: item, image: image)
    }
}


enum GeneralMenu : Int {
    case resetPassword = 2
}
