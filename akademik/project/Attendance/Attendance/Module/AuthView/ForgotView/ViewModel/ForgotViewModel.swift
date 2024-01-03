import UIKit
import RxSwift
import RxCocoa

class ForgotViewModel {
    
    // MARK: - Inputs
    
    let emailInput = BehaviorRelay<String>(value: "")
    let resetButtonTap = PublishSubject<Void>()
    let loginButtonTap = PublishSubject<Void>()

    // MARK: - Outputs
    
    let showAlert = PublishSubject<(String, String)>()

    // MARK: - Actions
    
    func resetPassword(email: String, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard !email.isEmpty else {
            showAlert.onNext(("Error", "Please fill in the email field."))
            return
        }

        FirebaseManager.shared.resetPassword(email: email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
