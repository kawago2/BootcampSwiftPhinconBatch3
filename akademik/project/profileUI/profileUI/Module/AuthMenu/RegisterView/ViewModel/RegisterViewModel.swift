import UIKit
import FirebaseAuth

class RegisterViewModel {
    
    // MARK: - Closures
    
    var onRegistrationSuccess: (() -> Void)?
    var onRegistrationFailure: ((String) -> Void)?

    // MARK: - User Registration
    
    func registerUser(email: String?, password: String?) {
        guard let email = email, let password = password else {
            onRegistrationFailure?("Invalid email or password.")
            return
        }
        FAuth.auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.onRegistrationFailure?(error.localizedDescription)
            } else {
                strongSelf.onRegistrationSuccess?()
            }
        }
    }
}
