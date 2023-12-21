import UIKit
import Lottie

class LoadingViewController: UIViewController {

    let animationView = LottieAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        // Setup animation view
        animationView.animation = LottieAnimation.named("loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        // Add animation view to the center of the screen
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
