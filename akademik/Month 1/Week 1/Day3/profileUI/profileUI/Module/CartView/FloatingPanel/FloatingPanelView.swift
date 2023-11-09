import UIKit

class FloatingPanelView: UIViewController {
    @IBOutlet weak var exitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func exitTapped(){
        self.dismiss(animated: true)
    }
    
    func setup() {
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
    }
}



