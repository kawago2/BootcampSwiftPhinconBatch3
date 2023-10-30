//
//  ProfileViewController.swift
//  profileUI
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    
    var titlePage = "profile_string".localized
    var name: String? = "Isi nama anda"
    var phone: String? = "0877777777"
    var email: String? = "isi email anda"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setNavTitle(title: titlePage)
    }
    
    @IBAction func penButtonTapped(_ sender: Any) {
        let vc = EditProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func setupUI() {
        // Set the profile image
        if let image = UIImage(named: "image_profile") {
            profileImg.image = image
            profileImg.setCircleBorder()
        }
        
        // Set shadow for the aboutView
        aboutView.setShadowRadius()
        
        // Set the labels
        nameTF.text = name
        phoneTF.text = phone
        emailTF.text = email
    }
}

