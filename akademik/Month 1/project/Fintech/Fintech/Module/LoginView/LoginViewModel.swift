import UIKit
import RxSwift
import FirebaseAuth


class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    
    
    func signInTapped(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        FirebaseManager.shared.signIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let authResult):
                print("Authentication successful")
                // Access user information from authResult.user if needed
                completion(.success(authResult))

            case .failure(let error):
                print("Authentication error: \(error.localizedDescription)")
                // Handle authentication error
                completion(.failure(error))
            }
        }
    }
}
