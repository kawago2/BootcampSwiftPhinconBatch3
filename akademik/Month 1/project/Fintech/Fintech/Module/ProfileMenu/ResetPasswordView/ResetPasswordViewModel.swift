import UIKit

class ResetPasswordViewModel {
    let titleNavigationBar = "Password"
    
    
    func resetPassword(oldPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseManager.shared.resetPasswordWithOldPassword(oldPassword: oldPassword, newPassword: newPassword, completion: {
            result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }
}
