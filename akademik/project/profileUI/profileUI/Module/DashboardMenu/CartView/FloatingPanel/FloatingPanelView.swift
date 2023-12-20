import UIKit
import RxSwift
// MARK: - Protocol

protocol FloatingPanelViewDelegate: AnyObject {
    func didConfirmTapped()
}

class FloatingPanelView: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!

    // MARK: - Properties
    
    weak var delegate: FloatingPanelViewDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        confirmButton.makeCornerRadius(20)
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        exitButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.exitTapped()
        }).disposed(by: disposeBag)
        
        confirmButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.confirmTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Handling
    
    private func exitTapped(){
        self.dismiss(animated: true)
    }
    
    private func confirmTapped(){
        exitTapped()
        delegate?.didConfirmTapped()
    }
    
    // MARK: - Passing Function
    
    internal func initData(sum: Float) {
        totalLabel?.text = sum.toDollarFormat()
    }
}



