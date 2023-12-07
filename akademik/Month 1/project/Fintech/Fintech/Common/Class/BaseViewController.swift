import UIKit
import RxSwift

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func backToView() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadingView(isHidden: Bool) {
        if isHidden {
            dismiss(animated: false)
        } else {
            let loadingVC = LoadingViewController()
            loadingVC.modalPresentationStyle = .overFullScreen
            present(loadingVC, animated: false, completion: nil)
        }
      
    }


}
