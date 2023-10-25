//
//  ViewController.swift
//  profileUI
//
//  Created by Phincon on 25/10/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var aboutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()        
    }

    func setup() {
        // Set the image
        if let image = UIImage(named: "image_profile") {
            profileImg.image = image
        }
        profileImg.setBorder()
        aboutView.setRadius()


    }

}
extension UIView {
    func setRadius(){
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.clipsToBounds = false
    }
}


extension UIImageView {
    func setBorder() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
