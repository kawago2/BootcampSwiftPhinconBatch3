import UIKit
import RxSwift
import RxCocoa

class ForgotViewModel {
    private let disposeBag = DisposeBag()

    // Inputs
    let emailInput = BehaviorRelay<String>(value: "")
    let resetButtonTap = PublishSubject<Void>()
    let loginButtonTap = PublishSubject<Void>()

    // Outputs
    let showAlert = PublishSubject<(String, String)>()
    let navigateToLogin = PublishSubject<Void>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        resetButtonTap
            .withLatestFrom(emailInput)
            .subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                self.resetPassword(email: email)
            })
            .disposed(by: disposeBag)

        loginButtonTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigateToLogin.onNext(())
            })
            .disposed(by: disposeBag)

    }
    
    func resetPassword(email: String) {
        guard !email.isEmpty else {
            self.showAlert.onNext(("Error", "Please fill email first."))
            return
        }

        FAuth.resetPassword(email: email) { result in
            switch result {
            case .success:
                print("Password reset email sent successfully.")
                self.showAlert.onNext(("Success", "Password reset email sent successfully\nPlease, check your email including spam."))
                self.navigateToLogin.onNext(())
            case .failure(let error):
                print("Failed to reset password with error: \(error.localizedDescription)")
                self.showAlert.onNext(("Error", "Failed to reset password. \(error.localizedDescription)"))
            }
        }
    }
}


