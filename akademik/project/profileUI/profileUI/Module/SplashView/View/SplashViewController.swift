import UIKit
import RxSwift

class SplashViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonNavigate: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: SplashViewModel!
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupAnimation()
        buttonEvent()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        buttonNavigate.makeCornerRadius(20)
    }
    
    // MARK: - Setup Animation
    
    private func setupAnimation() {
        viewModel.performInitialAnimation { [weak self] in
            self?.viewModel.rotateAnimateView()
        }
    }
    
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = SplashViewModel()
        viewModel.animateView = animateView
        viewModel.buttonNavigate = buttonNavigate
        viewModel.titleLabel = titleLabel
    }
    
    // MARK: - Setup Button Event
    
    private func buttonEvent() {
        buttonNavigate.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.navigateToNextPage()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
     private func navigateToNextPage() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}
