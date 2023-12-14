import UIKit
import RxSwift
import RxCocoa

// MARK: - Model

struct CardButton {
    var image: String?
    var title: String?
}

struct UserData {
    var uid: String?
    var email: String?
    var name: String?
    var createAt: Date?
    var phone: String?
    var areaCode: String?
    var imagePath: String?
    var imageURL: URL?
}

// MARK: - ViewModel

class ProfileViewModel {

    // MARK: - Public Methods
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

    func getImageFromURL(filePath: String, completion: @escaping (URL?, Error?) -> Void) {
        FirebaseManager.shared.getDownloadURLFromStorage(path: filePath) { (url, error) in
            if let error = error {
                completion(nil, error)
            } else if let url = url {
                completion(url, nil)
            }
        }
    }
}
