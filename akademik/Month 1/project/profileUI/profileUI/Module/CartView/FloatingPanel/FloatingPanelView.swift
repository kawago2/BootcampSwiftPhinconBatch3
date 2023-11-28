import UIKit

protocol FloatingPanelViewDelegate {
    func didConfirmTapped()
}

class FloatingPanelView: UIViewController {
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    var delegate: FloatingPanelViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func exitTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func confirmTapped(){
        exitTapped()
        delegate?.didConfirmTapped()
    }
    
    func setup() {
        confirmButton.makeCornerRadius(20)
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        
    }
    
    func initData(sum: Float) {
        totalLabel?.text = sum.toDollarFormat()
    }
}



