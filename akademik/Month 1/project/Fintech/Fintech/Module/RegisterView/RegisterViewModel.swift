import UIKit
import FirebaseAuth
import RxSwift
import RxRelay


class RegisterViewModel {
    // MARK: - Logic Function
    func registerTapped(name: String, email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        FirebaseManager.shared.register(withEmail: email, password: password, name: name) { result in
            switch result {
            case .success(let authResult):
                completion(.success(authResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

