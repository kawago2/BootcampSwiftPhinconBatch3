import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonNavigate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            // Animate translation and opacity for animateView
            self.animateView.transform = .identity
            self.animateView.alpha = 1
        } completion: { finished in
            if finished {
                self.rotateAnimateView()
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                    self.titleLabel.transform = .identity
                    self.titleLabel.alpha = 1
                }
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                    self.buttonNavigate.transform = .identity
                    self.buttonNavigate.alpha = 1
                }
            }
        }
    }
    
    private func rotateAnimateView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.animateView.transform = self.animateView.transform.rotated(by: .pi)
        } completion: { finished in
            if finished {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                    self.animateView.transform = self.animateView.transform.rotated(by: .pi)
                }
            }
        }
    }
    
    @objc func navigateToNextPage() {
        // Assuming TabBarViewController is the next view controller
        let loginController = LoginViewController()
        self.navigationController?.setViewControllers([loginController], animated: true)
    }
}


