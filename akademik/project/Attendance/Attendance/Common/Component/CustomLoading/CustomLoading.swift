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
        animationView.animation = LottieAnimation.named("loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        addSubview(animationView)
        setupConstraints()
    }

    private func setupConstraints() {
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
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
