import UIKit

// MARK: - Enums

enum Section: Int {
    case general = 0
    case security = 1
}

// MARK: - Structs

struct CellContent {
    var name: String
    var description: String?
}

// MARK: - View Model

class SettingViewModel {
    
    // MARK: - Properties
    
    let titleNavigationBar = "Settings"
    
    // MARK: - Public Methods
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseManager.shared.signOut { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
