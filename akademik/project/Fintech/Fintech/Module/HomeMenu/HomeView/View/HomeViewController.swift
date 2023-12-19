import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HomeViewModel!
    private var userData: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        setupUI()
        setupCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
    }
    
    private func setupUI() {
        
    }
    
    private func setupCell() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCellWithNib(HomeTopCell.self)
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HomeTopCell
        cell.configureData(userData: userData)
        return cell
    }
    
    
}

// Mark: - fetch Data
extension HomeViewController {
    private func getUserData() {
        loadingView(isHidden: false)
        let uid = FirebaseManager.shared.getCurrentUserUid()
        viewModel.getUserData(uid: uid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.userData = user ?? UserData()
                    self.updateUIData()
                case .failure(_):
                    self.showAlert(title: "Failed", message: "Failed to retrieve user data. Please try again.")
                }
                self.loadingView(isHidden: true)
            }
        }
    }
    
    private func updateUIData() {
        tableView.reloadData()
    }
}
