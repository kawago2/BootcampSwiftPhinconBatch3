import UIKit
import RxSwift
import RxCocoa

class SplashViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var viewModel: SplashViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        bindViewModel()
        viewModel.navigateToNextAfterDelay()
    }
    
    // MARK: - Setup
    
    private func setupViewModel() {
        viewModel = SplashViewModel()
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        viewModel.navigateToNextSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigateToNext()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    private func navigateToNext() {
        if !UserDefaultsManager.shared.getFirstInstall() {
            let vc = LoginViewController()
            navigationController?.setViewControllers([vc], animated: true)
        } else {
            UserDefaultsManager.shared.setFirstInstall(true)
            let vc = WelcomeViewController()
            navigationController?.setViewControllers([vc], animated: true)
            
        }
     
    }
}
