//
//  EditProfileViewController.swift
//  profileUI
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBAction func scrollButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ViewController {
              // Set the data on the destination view controller
              destinationViewController.name = nameTF.text
              destinationViewController.phone = phoneTF.text
              destinationViewController.email = emailTF.text
              
              // Replace the current view controller with the "ProfileViewController"
              if let navigation = self.navigationController {
                  navigation.setViewControllers([destinationViewController], animated: true)
              }
          }
    }
    
    func setup() {
        nameTF.keyboardType = .numberPad
    }
}
