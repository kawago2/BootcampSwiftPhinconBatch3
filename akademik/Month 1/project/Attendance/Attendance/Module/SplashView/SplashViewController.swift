import UIKit
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {
    
    var viewModel: SplashViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SplashViewModel()
        
        bindViewModel()
        
        viewModel.navigateToNextAfterDelay()
    }
    
    func bindViewModel() {
        viewModel.navigateToNext
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigateToNext()
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToNext() {
        let vc = WelcomeViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
}
