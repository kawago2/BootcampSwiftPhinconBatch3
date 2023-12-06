import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createWhenLabel: UILabel!
    
    // MARK: - Properties
    var userData = UserData()
    var menuItem: [CardButton] = []
    var viewModel = ProfileViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
    }

    // MARK: - Setup UI
    private func setupUI() {
        imageView.setCircleNoBorder()
        cardView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 30)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(CardButtonCell.self)
        tableView.separatorStyle = .none
    }
    
    // MARK: - Logic Bussiness
    private func loadData() {
        menuItem = [
            CardButton(image: CustomIcon.menuProfile, title: "My Account"),
            CardButton(image: CustomIcon.menuSetting, title: "Settings"),
            CardButton(image: CustomIcon.menuHelp, title: "Help Center"),
            CardButton(image: CustomIcon.menuTelp, title: "Contact")
        ]
    }
    
    private func getUserData() {
        let uid = FirebaseManager.shared.getCurrentUserUid()
        viewModel.getUserData(uid: uid, completion: {result in
            switch result {
            case .success(let user):
                self.userData = user ?? UserData()
                DispatchQueue.main.async {
                    self.updateUIData()
                }
            case .failure(_):
                self.showAlert(title: "Failed", message: "Failed to retrieve user data. Please try again.")
            }
        })
    }
    
    private func updateUIData() {
        nameLabel.text = userData.name
        emailLabel.text = userData.email
        if let createAt = userData.createAt {
            let formatDate = createAt.formattedDateString()
            let diffMonth = createAt.monthsDifference(from: Date())
            createWhenLabel.text = "You joined Brees on \(formatDate). It’s been \(diffMonth) month since then and our mission is still the same, help you better manage your finance like a brees."
        }

    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = menuItem[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardButtonCell", for: indexPath) as! CardButtonCell
        cell.configureCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = EditProfileViewController()
            vc.recieveData(item: userData)
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
