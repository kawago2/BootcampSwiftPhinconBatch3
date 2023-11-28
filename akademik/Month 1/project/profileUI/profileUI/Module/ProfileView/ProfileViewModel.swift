import UIKit
import FirebaseAuth

class ProfileViewModel {
    private let notSetText = "Not Set"
    private let defaultText = "No User"
//    private let image = "image_profile"
    
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
    
    // Make 'image' property accessible
    internal var image: String {
        return "image_profile"
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try FAuth.auth.signOut()
            completion(nil) // Sign-out successful
        } catch let signOutError as NSError {
            completion(signOutError) // Handle the error
        }
    }

    
}
