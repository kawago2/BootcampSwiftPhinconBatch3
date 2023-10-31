//
//  HomeViewController.swift
//  profileUI
//
//  Created by Phincon on 31/10/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var listMakananButton: UIButton!
    @IBOutlet weak var threadsButton: UIButton!
    @IBOutlet weak var listMinumanButton: UIButton!
    
    @IBOutlet weak var bannerButton: UIButton!
    
    @IBAction func listMakananButtonTapped(_ sender: Any) {
        let vc = TabelViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func listMinumanButtonTapped(_ sender: Any) {
        let vc = CollectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func bannerButtonTapped(_ sender: Any) {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func threadsButtonTapped(_ sender: Any) {
        let vc = ThreadsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setup() {
        let arrayButton = [listMakananButton, threadsButton, listMinumanButton]
        for x in arrayButton {
            x?.setRoundedBorder()
        }
    }


}
