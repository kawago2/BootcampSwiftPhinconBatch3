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
    }
    
    @IBAction func penButtonTapped(_ sender: Any) {
        let vc = EditProfileViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }


    func setupUI() {
        // Set the profile image
        if let image = UIImage(named: "image_profile") {
            profileImg.image = image
            profileImg.setCircleBorder()
        }
        
        // Set shadow for the aboutView
        aboutView.setShadow()
        
        // Set the labels
        nameTF.text = name
        phoneTF.text = phone
        emailTF.text = email
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func passData(image: [UIImagePickerController.InfoKey : Any], name: String, phone: String, email: String) {
        nameTF.text = name
        phoneTF.text = phone
        emailTF.text = email
        
        guard let image = image[.editedImage] as? UIImage else { return }
        profileImg.image = image
    }
}

