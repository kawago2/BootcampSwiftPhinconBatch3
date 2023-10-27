import UIKit

class ViewController: UIViewController {
    var titlePage = "profile_string".localized
    
    var name: String? = "Isi nama anda"
    var phone: String? = "0877777777"
    var email: String? = "isi email anda"
    
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func penButtonTapped(_ sender: Any) {
        let vc = EditProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeViewController", sender: nil)
    }
    
    func setup() {
        if let image = UIImage(named: "image_profile") {
            profileImg.image = image
        }
        
        profileImg.setCircleBorder()
        aboutView.setShadowRadius()
        
        nameTF.text = name
        phoneTF.text = phone
        emailTF.text = email
        customNavigator()
    }
    
    func customNavigator() {
        navigationItem.title = titlePage
//        navigationItem.style = back

        if let navigationBar = navigationController?.navigationBar {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 22),
                .foregroundColor: UIColor.systemBlue,
            ]
            navigationBar.titleTextAttributes = attrs
        }


        let editProfileButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(penButtonTapped))
        let homeButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(homeButtonTapped))
        navigationItem.rightBarButtonItem = editProfileButton
        navigationItem.leftBarButtonItem = homeButton
    }
}
