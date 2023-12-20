import UIKit
import FirebaseAuth

class LoginViewModel {
    
    // MARK: - Closures
    
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    // MARK: - User Authentication
    
    func signInWithFirebase(email: String?, password: String?) {
        guard let email = email, let password = password else {
            onLoginFailure?("Invalid email or password.")
            return
        }
        
        FAuth.auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.onLoginFailure?(error.localizedDescription)
            } else {
                strongSelf.onLoginSuccess?()
            }
        }
    }
}
