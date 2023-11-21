import UIKit

class SplashViewController: UIViewController {

    // Tambahkan property viewModel
    var viewModel: SplashViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Inisialisasi viewModel
        viewModel = SplashViewModel()

        // Panggil fungsi navigateToNextAfterDelay melalui viewModel
        viewModel.navigateToNextAfterDelay { [weak self] in
            self?.navigateToNext()
        }
    }

    func navigateToNext() {
        let vc = WelcomeViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
}
