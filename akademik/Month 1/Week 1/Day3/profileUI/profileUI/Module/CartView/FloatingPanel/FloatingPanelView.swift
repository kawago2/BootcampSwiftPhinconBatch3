import UIKit

class FloatingPanelView: UIViewController {
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func exitTapped(){
        self.dismiss(animated: true)
    }
    
    func setup() {
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        confirmButton.makeCornerRadius(20)
    }
    
    func initData(sum: Float) {
        totalLabel?.text = sum.toDollarFormat()
    }
}



