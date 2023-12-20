//
//  ChartViewController.swift
//  profileUI
//
//  Created by Phincon on 03/11/23.
//

import UIKit
import CoreData
import FloatingPanel
import RxSwift

// MARK: - Protocol

protocol CartViewDelegate: AnyObject {
    func passDataCart(listChart: [ItemModel])
}

class CartViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: CartViewDelegate?
    private var listChart: [ItemModel] = []
    private var listSeparated: [ItemModel] = []
    private var total: Float = 0 {
        didSet {
            if Int(self.total) == 0 {
                self.payButton.isEnabled = false
                self.payButton.tintColor = .gray
            }
        }
    }
    internal var context = ""
    private var fpc: FloatingPanelController!
    internal var combinedCart: [UUID: ItemModel] = [:]
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        configureTable()
        setupData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.context == "BottomCell" {
            self.showFloatingPanel()
        }
     
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        payButton.setRoundedBorder(cornerRadius: 20)
    }
    
    // MARK: - Setup Event
    
   private func setupEvent() {
        backButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backButtonTapped()
        }).disposed(by: disposeBag)
        
        payButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.payButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Pay Button Configure
    
    private func payButtonTapped() {
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
    
    // MARK: - Back Button Configure
    
    private func backButtonTapped() {
        separateLogic()
        delegate?.passDataCart(listChart: listSeparated)
        self.backToView()
    }
    
    private func separateLogic() {
        listSeparated = []
        for (_, item) in combinedCart {
            for _ in 1...item.quantity {
                var updated = item
                updated.quantity = 1
                listSeparated.append(updated)
            }
        }
    }
    
    // MARK: - Setup Data
    
    private func setupData() {
        totalPrice()
    }
    
    private func totalPrice() {
        total = combinedCart.values.reduce(0.0) { $0 + ($1.price ?? 0) * Float($1.quantity) }
        totalLabel.text = "Total: \(total.toDollarFormat())"
    }

}

// MARK: - Table View Configure

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(CartCell.self)
    }
    
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

// MARK: - Delegate Configure

extension CartViewController: CartCellDelegate, ResultViewControllerDelegate{
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
        let itemUUID = item.id
        
        if combinedCart[itemUUID] != nil {
            combinedCart[itemUUID] = nil
            if let index = listChart.firstIndex(where: { $0.id == itemUUID }) {
                listChart.remove(at: index)
            }
            totalPrice()
        }
        self.tableView.reloadData()
    }


    func didMinusTapped(_ item: ItemModel) {
        let itemUUID = item.id
        
        if let existingItem = combinedCart[itemUUID] {
            if existingItem.quantity > 1 {
                combinedCart[itemUUID]?.quantity -= 1
                totalPrice()
            }
        }
        self.tableView.reloadData()
    }


    func didPlusTapped(_ item: ItemModel) {
        let itemUUID = item.id
        
        if let _ = combinedCart[itemUUID] {
            combinedCart[itemUUID]?.quantity += 1
            totalPrice()
        }
        self.tableView.reloadData()
    }
    
}

// MARK: - Floating Configure Layout

extension CartViewController: FloatingPanelControllerDelegate, FloatingPanelViewDelegate {
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
