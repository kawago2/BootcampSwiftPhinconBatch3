import UIKit
import FirebaseAuth


class EditProfileViewModel {
    
    // MARK: - Properties
    
    private let authService: AuthService
    var userData: UserModel
    
    // MARK: - Initialization
    
    init(authService: AuthService, userData: UserModel) {
        self.authService = authService
        self.userData = userData
    }
    
    // MARK: - Update Display Name
    
    func updateDisplayName(_ displayName: String, completion: @escaping (Error?) -> Void) {
        authService.updateDisplayName(displayName, completion: completion)
    }

    
    // MARK: - Update Email
    
    func updateEmail(_ email: String, completion: @escaping (Error?) -> Void) {
        authService.updateEmail(email, completion: completion)
    }
}
