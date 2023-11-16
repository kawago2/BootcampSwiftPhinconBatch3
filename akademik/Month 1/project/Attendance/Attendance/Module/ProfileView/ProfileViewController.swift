import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var pencilButton: UIImageView!
    @IBOutlet weak var signoutButton: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var profileArray: [InfoItem] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        buttonEvent()
    }
    
    func buttonEvent() {
        let signout = UITapGestureRecognizer(target: self, action: #selector(signoutTapped))
        signoutButton.addGestureRecognizer(signout)
    }

    @objc func signoutTapped() {
        FAuth.logout { result in
            switch result {
            case .success:
                print("Logout successful")
                self.showAlert(title: "Success", message: "Logout successful") {
                    
                    self.navigateToLogin()
                }
                
                
            case .failure(let error):
                print("Logout failed with error: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Logout failed. \(error.localizedDescription)")
            }
        }
    }
    
     func navigateToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.05)
        profileView.makeCornerRadius(20)
        profileImage.makeCornerRadius(20)
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        nameLabel.text = FAuth.auth.currentUser?.displayName
    }
    
    func loadData() {
        profileArray.append(contentsOf: [
            InfoItem(title: "No. Karyawan", description: "NIK-0909090909", imageName: "identity"),
            InfoItem(title: "Alamat", description: "Jakarta Selatan", imageName: "address"),
            InfoItem(title: "Change Password", description: "***************", imageName: "password")
        ])
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let profile = profileArray[index]
        cell.initData(title: profile.title ?? "", desc: profile.description ?? "", img: profile.imageName ?? "image_not_available")
        cell.context = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
