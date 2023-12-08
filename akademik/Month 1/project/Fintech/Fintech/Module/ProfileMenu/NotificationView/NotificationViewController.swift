//
//  NotificationViewController.swift
//  Fintech
//
//  Created by Phincon on 08/12/23.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = viewModel.titleNavigationBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.registerCellWithNib(NotificationCell.self)
    }
}


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        switch indexPath.row {
        case 0:
            cell.setupName(name: "Transaction alert")
        case 1:
            cell.setupName(name: "Insight alert")
        case 2:
            cell.setupName(name: "Sort Transactions alert")
        default:
            break
        }
        cell.delegate = self
        return cell
    }
    
}

extension NotificationViewController: NotificationCellDelegate {
    func switchValueChanged(isOn: Bool) {
        print(isOn)
    }
    
    
}
