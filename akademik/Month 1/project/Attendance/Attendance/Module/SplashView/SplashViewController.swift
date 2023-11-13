import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToNextAfterDelay()
    }
    
    
    func navigateToNextAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToNext()
        }
    }

    func navigateToNext() {
        let vc = WelcomeViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
}

