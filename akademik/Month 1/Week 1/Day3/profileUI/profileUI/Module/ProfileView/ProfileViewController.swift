//
//  ProfileViewController.swift
//  profileUI
//
//  Created by Phincon on 30/10/23.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    
    var titlePage = "profile_string".localized
    let notSetText = "Not Set"
    let defaultText = "No User"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserData()
    }
    
    func setupUI() {
        // Set the profile image
        if let image = UIImage(named: "image_profile") {
            profileImg.image = image
            profileImg.setCircleBorder()
        }
        // Set shadow for the aboutView
        aboutView.setShadow()
    }
    
    func getUserData() {
        guard let user = Auth.auth().currentUser else {
            nameTF.text = defaultText
            phoneTF.text = defaultText
            emailTF.text = defaultText
            return
        }

        nameTF.text = user.displayName ?? notSetText
        emailTF.text = user.email ?? notSetText
        phoneTF.text = user.phoneNumber ?? notSetText
    }
    
    
    @IBAction func signoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let loginViewController = LoginViewController()
            navigationController?.setViewControllers([loginViewController], animated: true)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    @IBAction func penButtonTapped(_ sender: Any) {
        let vc = EditProfileViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func passData(image: [UIImagePickerController.InfoKey : Any]?, name: String?, phone: String?, email: String?) {
        if name != nil {
            nameTF.text = name
        }
        
        if phone != nil{
            phoneTF.text = phone
        }
        
        if email != nil {
            emailTF.text = email
        }
        
        if let imageDict = image, let validImage = imageDict[.editedImage] as? UIImage {
            profileImg.image = validImage
        }
    }
}

