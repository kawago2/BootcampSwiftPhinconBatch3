import UIKit
import Lottie

class LoadingViewController: UIViewController {

    // MARK: - Properties

    private let animationView = LottieAnimationView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupAnimationView()
    }

    private func setupAnimationView() {
        // Setup animation view
        animationView.animation = LottieAnimation.named("loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        // Add animation view to the center of the screen
        view.addSubview(animationView)
        setupConstraints()
    }

    private func setupConstraints() {
        animationView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
    }
}
