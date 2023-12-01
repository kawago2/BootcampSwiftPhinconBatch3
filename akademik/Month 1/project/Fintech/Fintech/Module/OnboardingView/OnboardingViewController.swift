//
//  OnboardingViewController.swift
//  Fintech
//
//  Created by Phincon on 01/12/23.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    
    var onboardingList: [Onboarding] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }

    
    private func setupUI() {
        cardView.roundCorners(corners: [.allCorners], cornerRadius: 30)
        skipButton.backgroundColor = .white.withAlphaComponent(0.10)
        skipButton.roundCorners(corners: [.allCorners], cornerRadius: 30)
        
        collectionView.registerCellWithNib(OnboardingCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func loadData() {
        onboardingList = [
            Onboarding(image: "onboard-1", title: "You ought to know where your money goes", description: "Get an overview of how you are performing and motivate yourself to achieve even more."),
            Onboarding(image: "onboard-2", title: "Gain total control of your money", description: "Track your transactions easily, with categories and financial reports."),
            Onboarding(image: "onboard-3", title: "Plan ahead and manage your money better", description: "Set up your budget for each category so you're in control. Track categories where you spend the most money.")
        ]
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        let onboarding = onboardingList[index]
        cell.configureImage(image: onboarding.image ?? "image_not_available")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 393, height: 275)
    }
    
}
