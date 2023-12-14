import UIKit
import RxSwift

class BaseViewController: UIViewController {

    // MARK: - Properties
    public let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Loading View
    public func loadingView(isHidden: Bool) {
        if isHidden {
            dismissLoadingView()
        } else {
            presentLoadingView()
        }
    }

    private func presentLoadingView() {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overFullScreen
        present(loadingVC, animated: false, completion: nil)
    }

    private func dismissLoadingView() {
        dismiss(animated: false)
    }

    // MARK: - Navigation
    public func backToView() {
        navigationController?.popViewController(animated: true)
    }

    public func dismisToParent() {
        dismiss(animated: true)
    }
}
