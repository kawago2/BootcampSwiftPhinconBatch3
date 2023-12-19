import UIKit
import FirebaseAuth

struct UserModel {
    var nama: String?
    var phone: String?
    var email: String?
    var image: String?
}

class ProfileViewModel {
    
    // MARK: - Constants
    
    private let notSetText = "Not Set"
    
    // MARK: - Computed Properties
    
    var name: String {
        return FAuth.auth.currentUser?.displayName ?? notSetText
    }
    
    var email: String {
        return FAuth.auth.currentUser?.email ?? notSetText
    }
    
    var phone: String {
        return FAuth.auth.currentUser?.phoneNumber ?? notSetText
    }
    
    var profileImage: UIImage {
        return UIImage(named: image) ?? UIImage()
    }
    
    var image: String {
        return "image_profile"
    }
    
    // MARK: - Sign Out
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try FAuth.auth.signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }
}
