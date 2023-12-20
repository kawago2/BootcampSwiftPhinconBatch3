import UIKit
import Lottie
import RxSwift

// MARK: - Protocol

protocol ResultViewControllerDelegate: AnyObject {
    func didFinishTapped()
}

class ResultViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var paymentView: LottieAnimationView!
    @IBOutlet weak var totalPayLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: ResultViewControllerDelegate?
    private var amount: Float = 0.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLottie()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateContentViewAppearance()
    }
    
    // MARK: - Setup UI
    
    func setupUI(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backView.layer.shadowRadius = 5
        contentView.makeCornerRadius(20)
        
        
        if Int(amount) == 0 {
            totalPayLabel.isHidden = true
        } else {
            totalPayLabel.text = "Total: " + amount.toDollarFormat()
        }
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        backButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.backTapped()
        }).disposed(by: disposeBag)
    }
    
    private func backTapped() {
        self.dismiss(animated: false)
        delegate?.didFinishTapped()
    }
    
    // MARK: - Setup Lottie
    
    private func setupLottie() {
        paymentView.loopMode = .playOnce
        paymentView.play()
    }
    
    // MARK: - Setup Animate
    
    private func animateContentViewAppearance() {
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
    
    private func navigateToNextViewControllerWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.backTapped()
        }
    }
    
    // MARK: - Passing Function
    
    internal func initData(amount: Float) {
        self.amount = amount
    }
}
