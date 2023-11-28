import FirebaseAuth

class AuthService {
    
    func updateDisplayName(_ displayName: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(AuthError.userNotLoggedIn)
            return
        }

        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.displayName = displayName

        changeRequest.commitChanges { commitError in
            completion(commitError)
        }
    }

    func updateEmail(_ email: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(AuthError.userNotLoggedIn)
            return
        }

        currentUser.updateEmail(to: email) { error in
            completion(error)
        }
    }
    
    // Additional authentication-related methods can be added here
}
