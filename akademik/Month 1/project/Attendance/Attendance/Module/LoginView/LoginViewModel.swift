import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {
    private let disposeBag = DisposeBag()

    // Inputs
    let emailInput = BehaviorRelay<String>(value: "")
    let passwordInput = BehaviorRelay<String>(value: "")
    let loginButtonTap = PublishSubject<Void>()

    // Outputs
    let showAlert = PublishSubject<(String, String)>()
    let navigateToTabBar = PublishSubject<Void>()
    let navigateToRegister = PublishSubject<Void>()
    let navigateToForgot = PublishSubject<Void>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        loginButtonTap
            .withLatestFrom(Observable.combineLatest(emailInput, passwordInput))
            .subscribe(onNext: { [weak self] email, password in
                self?.loginTapped(email: email, password: password)
            })
            .disposed(by: disposeBag)
    }

    private func loginTapped(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert.onNext(("Error", "Please fill in all fields."))
            return
        }

        FAuth.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Login berhasil, user: \(user)")
                self.navigateToTabBar.onNext(())

            case .failure(let error):
                print("Login gagal dengan error: \(error.localizedDescription)")
                self.showAlert.onNext(("Error", error.localizedDescription))
            }
        }
    }
}
