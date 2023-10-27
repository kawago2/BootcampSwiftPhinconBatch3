//
//  ViewController.swift
//  profileUI
//
//  Created by Phincon on 25/10/23.
//

import UIKit

class HomeViewController: UIViewController {
    let titlePage: String = "Home"
    
    @IBOutlet weak var listMakananButton: UIButton!
    @IBOutlet weak var threadsButton: UIButton!
    @IBOutlet weak var listMinumanButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        hiddenBack()
        setNavTitle(title: titlePage)

    }
    
    @IBAction func listMakananButtonTapped(_ sender: Any) {
        let vc = TabelViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func listMinumanButtonTapped(_ sender: Any) {
        let vc = CollectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func threadsButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ScrollViewController")
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func setup() {
        let arrayButton = [listMakananButton, threadsButton, listMinumanButton]
        for x in arrayButton {
            x?.setRoundedBorder()
        }
    }
}


