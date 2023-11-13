import UIKit
import FirebaseAuth

class RegisterViewModel {
    var onRegistrationSuccess: (() -> Void)?
    var onRegistrationFailure: ((String) -> Void)?

    func registerUser(email: String?, password: String?) {
        guard let email = email, let password = password else {
            onRegistrationFailure?("Invalid email or password.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.onRegistrationFailure?(error.localizedDescription)
            } else {
                strongSelf.onRegistrationSuccess?()
            }
        }
    }
}
