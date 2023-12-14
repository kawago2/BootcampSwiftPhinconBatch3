import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonNavigate: UIButton!
    
    private var viewModel: SplashViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        buttonNavigate.addTarget(self, action: #selector(navigateToNextPage), for: .touchUpInside)
    }
    
    
    private func setupUI() {
        let finalY = -self.view.frame.height
        let initY = self.view.frame.height
        let initX = -self.view.frame.width
        
        // Set initial positions and opacity
        animateView.transform = CGAffineTransform(translationX: 0, y: finalY)
        titleLabel.transform = CGAffineTransform(translationX: initX, y: 0)
        buttonNavigate.transform = CGAffineTransform(translationX: 0, y: initY)
        
        // Set initial opacity to 0 for all elements
        animateView.alpha = 0
        titleLabel.alpha = 0
        buttonNavigate.alpha = 0
        
        viewModel.performInitialAnimation { [weak self] in
            self?.viewModel.rotateAnimateView()
        }
    }
    
    private func setupViewModel() {
        viewModel = SplashViewModel()
        viewModel.animateView = self.animateView
        viewModel.buttonNavigate = self.buttonNavigate
        viewModel.titleLabel = self.titleLabel
    }
    
    @objc func navigateToNextPage() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}


