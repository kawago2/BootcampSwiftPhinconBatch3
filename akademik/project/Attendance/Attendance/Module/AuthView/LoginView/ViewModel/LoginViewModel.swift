import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {

    // MARK: - Inputs
    
    let emailInput = BehaviorRelay<String>(value: "")
    let passwordInput = BehaviorRelay<String>(value: "")
    let loginButtonTap = PublishSubject<Void>()

    // MARK: - Outputs
    
    let showAlert = PublishSubject<(String, String)>()
    let navigateToTabBar = PublishSubject<Void>()
    let navigateToRegister = PublishSubject<Void>()
    let navigateToForgot = PublishSubject<Void>()

    // MARK: - Private properties
    
    private let disposeBag = DisposeBag()

    // MARK: - Initialization
    
    init() {
        setupBindings()
    }

    // MARK: - Bindings
    
    private func setupBindings() {
        loginButtonTap
            .withLatestFrom(Observable.combineLatest(emailInput, passwordInput))
            .subscribe(onNext: { [weak self] email, password in
                guard let self = self else { return }
                self.loginTapped(email: email, password: password)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    
    private func loginTapped(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert.onNext(("Error", "Please fill in all fields."))
            return
        }

        FAuth.loginUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.navigateToTabBar.onNext(())

            case .failure(let error):
                self.showAlert.onNext(("Error", error.localizedDescription))
            }
        }
    }
}
