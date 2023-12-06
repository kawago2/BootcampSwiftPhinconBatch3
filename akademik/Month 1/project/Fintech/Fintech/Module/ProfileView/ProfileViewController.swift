//
//  ProfileViewController.swift
//  Fintech
//
//  Created by Phincon on 05/12/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        imageView.setCircleNoBorder()
        cardView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 30)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(CardButtonCell.self)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
