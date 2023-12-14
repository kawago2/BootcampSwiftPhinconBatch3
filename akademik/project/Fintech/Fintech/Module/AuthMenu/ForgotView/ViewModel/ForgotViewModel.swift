import UIKit

class ForgotViewModel {
    // MARK: - Logic Function
    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseManager.shared.forgotPassword(forEmail: email) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
