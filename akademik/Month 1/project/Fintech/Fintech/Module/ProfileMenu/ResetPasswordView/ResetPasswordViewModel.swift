import UIKit

// MARK: - ResetPasswordViewModel

class ResetPasswordViewModel {
    
    // MARK: - Properties
    
    let titleNavigationBar = "Password"
    
    // MARK: - Public Methods
    
    func resetPassword(oldPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseManager.shared.resetPasswordWithOldPassword(oldPassword: oldPassword, newPassword: newPassword) { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
