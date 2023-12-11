//
//  InsightViewController.swift
//  Fintech
//
//  Created by Phincon on 11/12/23.
//

import UIKit

class InsightViewController: BaseViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var differentLabel: UILabel!
    
    let viewModel = InsightViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        cardView.roundCorners(corners: [.allCorners], cornerRadius: 30)
        navigationBar.centerLabel.textColor = .white
        navigationBar.titleNavigationBar = viewModel.titleNavigationBar
    }
}
