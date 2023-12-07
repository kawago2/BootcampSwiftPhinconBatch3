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
    var phone: String?
    var imagePath: String?
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
    
    func getImageFromURL(filePath: String, completion: @escaping (URL?, Error?) -> Void) {
        FirebaseManager.shared.getDownloadURLFromStorage(path: filePath) { (url, error) in
            if let error = error {
                print("Failed to get download URL. Error: \(error.localizedDescription)")
                completion(nil, error)
            } else if let url = url {
                print("Download URL: \(url)")
                completion(url, nil)
            }
        }
    }
}
