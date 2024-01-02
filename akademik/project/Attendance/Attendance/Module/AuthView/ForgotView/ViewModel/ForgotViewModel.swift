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
    let navigateToLogin = PublishSubject<Void>()

    // MARK: - Private properties
    
    private let disposeBag = DisposeBag()

    // MARK: - Initialization
    
    init() {
        setupBindings()
    }

    // MARK: - Bindings
    
    private func setupBindings() {
        resetButtonTap
            .withLatestFrom(emailInput)
            .subscribe(onNext: { [weak self] email in
                self?.resetPassword(email: email)
            })
            .disposed(by: disposeBag)

        loginButtonTap
            .subscribe(onNext: { [weak self] in
                self?.navigateToLogin.onNext(())
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    
    func resetPassword(email: String) {
        guard !email.isEmpty else {
            showAlert.onNext(("Error", "Please fill in the email field."))
            return
        }

        FirebaseManager.shared.resetPassword(email: email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showAlert.onNext(("Success", "Password reset email sent successfully.\nPlease check your email, including spam."))
                self.navigateToLogin.onNext(())
            case .failure(let error):
                self.showAlert.onNext(("Error", "Failed to reset password. \(error.localizedDescription)"))
            }
        }
    }
}
