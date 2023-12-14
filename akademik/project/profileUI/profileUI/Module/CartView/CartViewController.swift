//
//  ChartViewController.swift
//  profileUI
//
//  Created by Phincon on 03/11/23.
//

import UIKit
import CoreData
import FloatingPanel


protocol CartViewDelegate {
    func passDataCart(listChart: [ItemModel])
}

class CartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    var listChart: [ItemModel] = []
    var uniqueCart: [ItemModel] = []
    var listSeparated: [ItemModel] = []
    var total: Float = 0 {
        didSet {
            if Int(self.total) == 0 {
                self.payButton.isEnabled = false
                self.payButton.tintColor = .gray
            }
        }
    }
    var context = ""
    var fpc: FloatingPanelController!
    var combinedCart: [UUID: ItemModel] = [:]
    var delegate: CartViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup()
        configureTable()
        setupData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.context == "BottomCell" {
            self.showFloatingPanel()
        }
     
    }
    @objc func backButtonTapped(_ sender: Any) {
        separateLogic()
        delegate?.passDataCart(listChart: listSeparated)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func payButtonTapped() {
        showFloatingPanel()
    }
    
    private func showFloatingPanel() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.panGestureRecognizer.isEnabled = false
        fpc.surfaceView.makeCornerRadius(20)
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        let vc = FloatingPanelView()
        vc.delegate = self
        fpc.set(contentViewController: vc)
        vc.initData(sum: total)
        fpc.layout = CustomFloatingPanelLayout()
        fpc.isRemovalInteractionEnabled = true
        vc.view.layoutIfNeeded()
        present(fpc, animated: true, completion: nil)
    }
    
    func setup() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        payButton.setRoundedBorder(cornerRadius: 20)
    }
    
    func setupData() {
        totalPrice()
    }
    
    func totalPrice() {
        total = combinedCart.values.reduce(0.0) { $0 + ($1.price ?? 0) * Float($1.quantity) }
        totalLabel.text = "Total: \(total.toDollarFormat())"
    }

    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(CartCell.self)
    }
    
    func separateLogic() {
        listSeparated = []
        for (_, item) in combinedCart {
            for _ in 1...item.quantity {
                var updated = item
                updated.quantity = 1
                listSeparated.append(updated)
            }
        }
        print(listSeparated)
    }

}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinedCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.selectionStyle = .none
        cell.delegate = self
        let keyAtIndex = Array(combinedCart.keys)[index]
        let valueAtIndex = combinedCart[keyAtIndex]
        cell.item = valueAtIndex
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
}

extension CartViewController: CartCellDelegate, FloatingPanelViewDelegate, ResultViewControllerDelegate{
    func didFinishTapped() {
        let vc = TabBarViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func didConfirmTapped() {
        let vc = ResultViewController()
        vc.delegate = self
        vc.initData(amount: total)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false)
    }
    
    func didTashTapped(_ item: ItemModel) {
        let itemUUID = item.id // Assuming item.id is not optional
        
        if combinedCart[itemUUID] != nil {
            combinedCart[itemUUID] = nil
            // Reload the table view with the updated data
            if let index = listChart.firstIndex(where: { $0.id == itemUUID }) {
                listChart.remove(at: index)
            }
            totalPrice()
        }
        self.tableView.reloadData()
    }


    func didMinusTapped(_ item: ItemModel) {
        let itemUUID = item.id // Assuming item.id is not optional
        
        if let existingItem = combinedCart[itemUUID] {
            if existingItem.quantity > 1 {
                combinedCart[itemUUID]?.quantity -= 1
                totalPrice()
            }
        }
        self.tableView.reloadData()
    }


    func didPlusTapped(_ item: ItemModel) {
        let itemUUID = item.id // Assuming item.id is not optional
        
        if let existingItem = combinedCart[itemUUID] {
            combinedCart[itemUUID]?.quantity += 1
            totalPrice()
        }
        self.tableView.reloadData()
    }
    
}

extension CartViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        if targetState.pointee != .full {
            fpc.dismiss(animated: true)
        }
    }
}

class CustomFloatingPanelLayout: FloatingPanelLayout {
    var position: FloatingPanel.FloatingPanelPosition = .bottom

    var initialState: FloatingPanel.FloatingPanelState = .tip

    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring] = [
        .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
    ]

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.30
    }
}
