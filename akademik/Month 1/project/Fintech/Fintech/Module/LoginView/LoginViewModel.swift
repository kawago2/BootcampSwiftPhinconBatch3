import UIKit
import RxSwift
import FirebaseAuth


class LoginViewModel {
    
    func signInTapped(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        FirebaseManager.shared.signIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let authResult):
                completion(.success(authResult))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
