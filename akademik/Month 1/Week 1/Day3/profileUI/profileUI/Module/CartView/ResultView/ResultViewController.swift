

import UIKit
import Lottie

protocol ResultViewControllerDelegate {
    func didFinishTapped()
}

class ResultViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var paymentView: LottieAnimationView!
    @IBOutlet weak var totalPayLabel: UILabel!
    
    var delegate: ResultViewControllerDelegate?
    
    var amount: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateContentViewAppearance()
    }
    
    
    @objc func backTapped() {
        self.dismiss(animated: false)
        delegate?.didFinishTapped()
    }
    
    func setup(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backView.layer.shadowRadius = 5
        contentView.makeCornerRadius(20)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        setupLottie()
        
        if Int(amount) == 0 {
            totalPayLabel.isHidden = true
        } else {
            totalPayLabel.text = "Total: " + amount.toDollarFormat()
        }
    }
    
    func setupLottie() {
        paymentView.loopMode = .playOnce
        paymentView.play()
    }
    
    func animateContentViewAppearance() {
        let startPosition = CGPoint(x: contentView.center.x, y: view.bounds.height + contentView.bounds.height / 2)
        contentView.center = startPosition
        contentView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.center = self.view.center
            self.contentView.alpha = 1.0
        }, completion: { finished in
            if finished {
                self.navigateToNextViewControllerWithDelay()
            }
        })
    }

    func navigateToNextViewControllerWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.backTapped()
        }
    }
    
    func initData(amount: Float) {
        self.amount = amount
    }
}
