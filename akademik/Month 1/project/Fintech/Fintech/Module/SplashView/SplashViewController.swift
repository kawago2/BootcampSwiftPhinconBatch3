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
        timerTo()
    }
    
    private func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.20)
    }
    
    private func timerTo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.nextPage()
        })
    }
    
    private func nextPage() {
        let vc = OnboardingViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}
