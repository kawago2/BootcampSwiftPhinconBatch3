import UIKit
import Lottie
import SnapKit

class CustomLoading: UIView {
    @IBOutlet var lottieView: LottieAnimationView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        lottieView = LottieAnimationView(name: "loading")
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        
        addSubview(lottieView)
        
        lottieView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func startAnimating() {
        self.isHidden = false
        lottieView.play()
    }
    
    func stopAnimating() {
        self.isHidden = true
        lottieView.stop()
    }
}
