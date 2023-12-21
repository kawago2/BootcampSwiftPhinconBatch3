import UIKit
import RxSwift
import RxCocoa

class RegisterViewModel {
    private let disposeBag = DisposeBag()

    // Inputs
    let fullnameInput = BehaviorRelay<String>(value: "")
    let emailInput = BehaviorRelay<String>(value: "")
    let passwordInput = BehaviorRelay<String>(value: "")
    let repasswordInput = BehaviorRelay<String>(value: "")
    let registerButtonTap = PublishSubject<Void>()

    // Outputs
    let showAlert = PublishSubject<(String, String, (() -> Void)?)>()
    let navigateToLogin = PublishSubject<Void>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        registerButtonTap
            .withLatestFrom(Observable.combineLatest(fullnameInput, emailInput, passwordInput, repasswordInput))
            .subscribe(onNext: { [weak self] fullname, email, password, repassword in
                guard let self = self else { return }
                self.registerTapped(fullname: fullname, email: email, password: password, repassword: repassword)
            })
            .disposed(by: disposeBag)
    }

    private func registerTapped(fullname: String, email: String, password: String, repassword: String) {
        guard !email.isEmpty, !password.isEmpty, !repassword.isEmpty, !fullname.isEmpty else {
            showAlert.onNext(("Error", "Please fill in all fields.", nil))
            return
        }

        guard password == repassword else {
            showAlert.onNext(("Error", "Passwords do not match.", nil))
            return
        }

        FirebaseManager.shared.registerUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                let uid = user.uid
                let collection = "users"
                let documentID = uid
                let updatedData = [
                    "profile": [
                        "name": fullname
                    ]
                ]

                FirebaseManager.shared.setDocument(documentID: documentID, data: updatedData, inCollection: collection) { result in
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        self.showAlert.onNext(("Error", "Error updating profile: \(error.localizedDescription)", nil))
                    }
                }

                self.showAlert.onNext(("Success", "Registration Successful.", {
                    self.navigateToLogin.onNext(())
                }))

            case .failure(let error):
                self.showAlert.onNext(("Error", error.localizedDescription, nil))
            }
        }
    }
}
