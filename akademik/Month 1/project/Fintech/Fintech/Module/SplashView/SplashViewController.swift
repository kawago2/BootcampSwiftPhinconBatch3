// MARK: - SplashViewController
import UIKit

class SplashViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var circleView: UIImageView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        timerTo()
    }
    // MARK: - Private methods
    private func setupUI() {
        circleView.tintColor = .white.withAlphaComponent(0.20)
    }
    
    private func timerTo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.nextPage()
        })
    }
    
    // MARK: - Navigate
    private func nextPage() {
        let vc = OnboardingViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}
