import UIKit
import FirebaseAuth


class EditProfileViewModel {
    private let authService: AuthService
    var userData: UserModel
    
    init(authService: AuthService, userData: UserModel) {
        self.authService = authService
        self.userData = userData
    }
    
    func updateDisplayName(_ displayName: String, completion: @escaping (Error?) -> Void) {
        authService.updateDisplayName(displayName, completion: completion)
    }

    func updateEmail(_ email: String, completion: @escaping (Error?) -> Void) {
        authService.updateEmail(email, completion: completion)
    }
}
