import UIKit

class EditProfileViewController: UIViewController {
    var titlePage = "Edit Profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNavTitle(title: titlePage)

    }
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBAction func scrollButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ViewController {
              
              destinationViewController.name = nameTF.text
              destinationViewController.phone = phoneTF.text
              destinationViewController.email = emailTF.text
              
              if let navigation = self.navigationController {
                  navigation.setViewControllers([destinationViewController], animated: true)
              }
          }
    }
    
    func setup() {
        nameTF.keyboardType = .numberPad
    }
}
