import UIKit
import RxSwift
import RxCocoa

struct CardButton {
    var image: String?
    var title: String?
}

struct UserData {
    var uid: String?
    var email: String?
    var name: String?
    var createAt: Date?
}


class ProfileViewModel {

    func getUserData(uid: String, completion: @escaping (Result<UserData?, Error>) -> Void) {
        FirebaseManager.shared.getUserDocument(uid: uid) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
