import UIKit
import RxSwift
import RxGesture

// MARK: - CustomPopUpViewDelegate

protocol CustomPopUpViewDelegate: AnyObject {
    func configurePopUp()
}

// MARK: - CustomPopUpViewController
class CustomPopUpViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var exitView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var goButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: CustomPopUpViewDelegate?
    private var customData = CustomPopUp()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        cardView.roundCorners(corners: .allCorners, cornerRadius: 20)
        goButton.roundCorners(corners: .allCorners, cornerRadius: 20)

        goButton.backgroundColor = .white
        goButton.setTitleColor(UIColor(named: ColorName.primary), for: .normal)

        view.backgroundColor = .black.withAlphaComponent(0.45)

        goButton.setTitle(customData.titleButton, for: .normal)
        imageView.image = UIImage(named: customData.image ?? CustomImage.notAvailImage)
    }
    
    // MARK: - Event Setup
    private func setupEvent() {
        backgroundButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        exitView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else{return}
            self.dismisToParent()
        }).disposed(by: disposeBag)
    }
}

// MARK: - Extension
extension CustomPopUpViewController {
    func configurePopUp(item: CustomPopUp) {
        customData = item
    }
}


