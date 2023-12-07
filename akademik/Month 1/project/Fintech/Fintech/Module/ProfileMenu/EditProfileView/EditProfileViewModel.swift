import UIKit
import FirebaseStorage


class EditProfileViewModel {
    let titleNavigationBar = "My Account"
        
    func saveToFirebase(item: UserData, completion: @escaping (Result<Void, Error>) -> Void) {
        let updatedData: [String: Any] = [
            "name": item.name ?? "",
            "phone": item.phone ?? "",
            "imagePath": item.imagePath ?? "",
        ]
        
        FirebaseManager.shared.editUserDocument(uid: item.uid ?? "", updatedUserData: updatedData) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadImageToStorage(userImage: UIImageView, item: UserData, completion: @escaping (StorageMetadata?, Error?) -> Void) {
        if let imageData = userImage.image?.jpegData(compressionQuality: 0.8) {
            let path = "profileImages/\(item.uid ?? "1").jpg"
            
            FirebaseManager.shared.uploadFileToStorage(data: imageData, path: path) { (metadata, error) in
                if let error = error {
                    completion(nil, error)
                } else if let metadata = metadata {
                    let path = metadata.path
                    print("Path: \(path ?? "N/A")")
                    completion(metadata, nil)
                }
            }
        }
    }

}
