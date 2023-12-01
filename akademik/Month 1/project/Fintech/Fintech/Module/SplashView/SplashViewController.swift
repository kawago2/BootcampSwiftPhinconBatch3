//
//  SplashViewController.swift
//  Fintech
//
//  Created by Phincon on 01/12/23.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var circleView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.20)
    }
}
