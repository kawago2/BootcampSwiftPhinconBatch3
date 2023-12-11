//
//  InsightViewController.swift
//  Fintech
//
//  Created by Phincon on 11/12/23.
//

import UIKit

class InsightViewController: BaseViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var differentLabel: UILabel!
    @IBOutlet weak var threadLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    private let vsLastWeekString = " vs last week"
    private let percentageValue = 4.3
    let viewModel = InsightViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        topView.roundCorners(corners: [.allCorners], cornerRadius: 30)
        cardView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 20)
        navigationBar.centerLabel.textColor = .white
        navigationBar.titleNavigationBar = viewModel.titleNavigationBar
        threadLabel.textColor = .white.withAlphaComponent(0.70)
        
        setupLabel()
    }
    
    private func setupLabel() {
        let percentageString = String(format: "+%.1f%%", percentageValue)
        let percentageAttributedString = viewModel.makeAttributedString(with: percentageString, color: .green)
        let vsLastWeekAttributedString = viewModel.makeAttributedString(with: vsLastWeekString, color: .white)

        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(percentageAttributedString)
        combinedAttributedString.append(vsLastWeekAttributedString)

        differentLabel.attributedText = combinedAttributedString
    }

}
