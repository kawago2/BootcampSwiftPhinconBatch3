//
//  ViewController.swift
//  profileUI
//
//  Created by Phincon on 25/10/23.
//

import UIKit

class ViewController: UIViewController {
    var name: String? = "Kaleb Gomgom Edward"
    var phone: String? = "08777777"
    var email: String? = "admin@gmail.com"
    
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()        
    }
    // XIB navigate
    @IBAction func TableviewButtonTapped(_ sender: Any) {
        let vc = TabelViewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // XIB navigate
    @IBAction func penButtonTapped(_ sender: Any) {
        let vc = EditProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Segue navigate
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeViewController", sender: nil)
    }
    
    // Storyboard navigate
    @IBAction func scrollButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ScrollViewController")
                self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    

    func setup() {
        // Set the image
        if let image = UIImage(named: "image_profile") {
            profileImg.image = image
        }
        
        profileImg.setCircleBorder()
        aboutView.setRadius()
        titleLabel.setBold()
        
        nameTF.text = name
        phoneTF.text = phone
        emailTF.text = email
    }

}




