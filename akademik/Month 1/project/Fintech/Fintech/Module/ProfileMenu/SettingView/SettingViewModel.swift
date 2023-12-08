import UIKit

enum Section: Int {
    case general = 0
    case security = 1
}

struct CellContent {
    var name: String
    var description: String?
}


class SettingViewModel {
    
    let titleNavigationBar = "Settings"
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseManager.shared.signOut { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
