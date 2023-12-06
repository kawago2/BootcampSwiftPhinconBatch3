import UIKit
import RxSwift

class EditProfileViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    
    private var userData = UserData()
    private let titleNavigationBar = "My Account"
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    private func setupUI() {
        navigationBar.titleNavigationBar = titleNavigationBar
        navigationBar.setupLeadingButton()
        saveButton.roundCorners(corners: .allCorners, cornerRadius: 20)
        cameraButton.setCircleNoBorder()
        cameraView.makeCircle()
        userImage.setCircleNoBorder()
    }
    
    private func setupEvent() {
        navigationBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backTapped()
        }).disposed(by: disposeBag)
        
    }
    
    func recieveData(item: UserData) {
        self.userData = item
    }
    
    private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    

}

