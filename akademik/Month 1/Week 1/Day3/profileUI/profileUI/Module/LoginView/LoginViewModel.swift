import UIKit
import FirebaseAuth

class LoginViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    func signInWithFirebase(email: String?, password: String?) {
        guard let email = email, let password = password else {
            onLoginFailure?("Invalid email or password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.onLoginFailure?(error.localizedDescription)
            } else {
                strongSelf.onLoginSuccess?()
            }
        }
    }
}
