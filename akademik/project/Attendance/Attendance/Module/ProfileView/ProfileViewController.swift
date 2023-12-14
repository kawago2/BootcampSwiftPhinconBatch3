import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture

class ProfileViewController: UIViewController {
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
    
    var profileArray: [InfoItem] = []
    var profileData = ProfileItem()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonEvent()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataGeneral()
    }
    func buttonEvent() {
        signoutButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.signoutTapped()
            })
            .disposed(by: disposeBag)
        
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
    }

     func signoutTapped() {
        FAuth.logout { result in
            switch result {
            case .success:
                print("Logout successful")
                self.navigateToLogin()
            case .failure(let error):
                print("Logout failed with error: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Logout failed. \(error.localizedDescription)")
            }
        }
    }
    
     func navigateFP() {
        let contentVC = EditProfileViewController()
        contentVC.delegate = self
        contentVC.initData(item: profileData)
        let navController = UINavigationController(rootViewController: contentVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)

    }
    
     func navigateToLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    
     func navigateToPayroll() {
        let vc = PayrollViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.05)
        profileView.makeCornerRadius(20)
        profileImage.makeCornerRadius(20)
        tableView.registerCellWithNib(LocationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupData() {
        self.nameLabel.text = profileData.name
        self.posisiLabel.text = profileData.posisi
    }
    

    
    func loadDataGeneral() {
        guard let uid = FAuth.auth.currentUser?.uid else {
            return
        }
        
        let collection = "users"
        let documentID = uid
        
        FFirestore.getDocument(collection: collection, documentID: documentID) { result in
            switch result {
            case .success(let document):
                if let profileData = document.data()?["profile"] as? [String: Any] {
                    let nik = profileData["nik"] as? String ?? "Not set"
                    let alamat = profileData["alamat"] as? String ?? "Not set"
                    let name = profileData["name"] as? String ?? "Not set"
                    let posisi = profileData["posisi"] as? String ?? "Not set"
                    

                    self.profileData = ProfileItem(nik: nik, alamat: alamat,name: name,posisi: posisi)
                    
                    self.profileArray = [
                        InfoItem(title: "No. Karyawan", description: nik, imageName: "identity"),
                        InfoItem(title: "Alamat", description: alamat, imageName: "address"),
                        InfoItem(title: "Change Password", description: "***************", imageName: "password")
                    ]
                    self.tableView.reloadData()
                } else {
                    self.profileArray = [
                        InfoItem(title: "No. Karyawan", description: self.profileData.nik, imageName: "identity"),
                        InfoItem(title: "Alamat", description: self.profileData.alamat, imageName: "address"),
                        InfoItem(title: "Change Password", description: "***************", imageName: "password")
                    ]
                    
                    self.tableView.reloadData()
                }
                self.setupData()

            case .failure(let error):
                print("Error fetching user profile from Firestore: \(error.localizedDescription)")
            }
        }
        
        let imagePath = "images/profile-\(uid)"
        FStorage.getImageURL(atPath: imagePath) { result in
            switch result {
            case .success(let imageURL):
                if let url = URL(string: imageURL) {
                    self.profileImage.kf.setImage(with: url)
                    self.profileData.imageUrl = imageURL
                } else {
                    print("Invalid URL")
                }
            case .failure(let error):
                print("Error retrieving image URL: \(error.localizedDescription)")
                self.profileImage.image = UIImage(named: "image_not_available")
            }
        }

    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let profile = profileArray[index]
        cell.initData(item: profile)
        cell.context = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row

        switch index {
        case 2:
            if let userEmail = FAuth.auth.currentUser?.email {
                FAuth.resetPassword(email: userEmail) { result in
                    switch result {
                    case .success:
                        print("Password reset email sent successfully.")
                        self.showAlert(title: "Success", message: "Password reset email sent successfully\nPlease Check your email.")
                    case .failure(let error):
                        print("Error resetting password: \(error.localizedDescription)")
                        self.showAlert(title: "Error", message: "Failed to reset password. \(error.localizedDescription)")
                    }
                }
            } else {
                self.showAlert(title: "Error", message: "User email is not available.")
            }
        default:
            break
        }
    }
}


extension ProfileViewController: EditProfileViewDelegate {
    func didSaveTapped(item: ProfileItem, image: UIImage?) {
        guard
            let nik = item.nik,
            let alamat = item.alamat,
            let name = item.name,
            let posisi = item.posisi
        else {
            return showAlert(title: "Invalid Field", message: "Please Fill")
        }
        
        guard let uid = FAuth.auth.currentUser?.uid else {
            return
        }
        
        let collection = "users"
        let documentID = uid
        
        let oldData = [
            "profile.nik": profileData.nik,
            "profile.alamat": profileData.alamat,
            "profile.name": profileData.name,
            "profile.posisi": profileData.posisi
        ]
        
        let updatedData = [
            "profile.nik": nik,
            "profile.alamat": alamat,
            "profile.name": name,
            "profile.posisi": posisi
        ]
        
        let dispatchGroup = DispatchGroup()
        
        
        
        if oldData != updatedData {
            dispatchGroup.enter()
            FFirestore.editDocument(inCollection: collection, documentIDToEdit: documentID, newData: updatedData) { result in
                switch result {
                case .success:
                    print("Profile updated successfully")
                    dispatchGroup.leave()
                case .failure(let error):
                    print("Error updating profile: \(error.localizedDescription)")
                }
            }
        }

        if let imageToUpload = image {
            let storagePath = "images/profile-\(uid)"
            dispatchGroup.enter()
            FStorage.uploadImage(imageToUpload, toPath: storagePath) { result in
                switch result {
                case .success(let downloadURL):
                    print("Image uploaded successfully. Download URL: \(downloadURL)")
                    dispatchGroup.leave()
                case .failure(let error):
                    print("Error uploading image: \(error.localizedDescription)")
                }
            }
        }
        // Notify when both tasks are completed
        dispatchGroup.notify(queue: .main) {
            self.showAlert(title: "Success", message: "Profile and Photo updated successfully") {
                self.loadDataGeneral()
            }
        }
    }
}
