import UIKit

class SplashViewModel {
    
    // MARK: - Properties
    
    var animateView: UIView!
    var titleLabel: UILabel!
    var buttonNavigate: UIButton!
    
    // MARK: - Public Methods
    
    func performInitialAnimation(completion: @escaping () -> Void) {
        let finalY = -UIScreen.main.bounds.height
        let initY = UIScreen.main.bounds.height
        let initX = -UIScreen.main.bounds.width
        
        // Set initial positions and opacity
        animateView.transform = CGAffineTransform(translationX: 0, y: finalY)
        titleLabel.transform = CGAffineTransform(translationX: initX, y: 0)
        buttonNavigate.transform = CGAffineTransform(translationX: 0, y: initY)
        
        // Set initial opacity to 0 for all elements
        animateView.alpha = 0
        titleLabel.alpha = 0
        buttonNavigate.alpha = 0
        
        // Perform animations
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            // Animate translation and opacity for animateView
            self.animateView.transform = .identity
            self.animateView.alpha = 1
        } completion: { finished in
            if finished {
                self.rotateAnimateView()
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                    // Animate translation and opacity for titleLabel
                    self.titleLabel.transform = .identity
                    self.titleLabel.alpha = 1
                }
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                    // Animate translation and opacity for buttonNavigate
                    self.buttonNavigate.transform = .identity
                    self.buttonNavigate.alpha = 1
                } completion: { _ in
                    completion()
                }
            }
        }
    }
    
    func rotateAnimateView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {            self.animateView.transform = self.animateView.transform.rotated(by: .pi)
        } completion: { finished in
            if finished {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                    self.animateView.transform = self.animateView.transform.rotated(by: .pi)
                }
            }
        }
    }
}
