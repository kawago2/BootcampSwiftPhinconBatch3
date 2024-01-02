import UIKit
import Lottie

class CustomLoading: UIView {

    // MARK: - Properties

    private let animationView = LottieAnimationView()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupAnimationView()
    }

    private func setupAnimationView() {
        // Setup animation view
        animationView.animation = LottieAnimation.named("loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        // Add animation view to the center of the view
        addSubview(animationView)
        setupConstraints()
    }

    private func setupConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Public Methods

    func show() {
        isHidden = false
        animationView.play()
    }

    func hide() {
        isHidden = true
        animationView.stop()
    }
}
