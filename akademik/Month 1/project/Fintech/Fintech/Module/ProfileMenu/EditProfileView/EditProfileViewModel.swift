import UIKit


class EditProfileViewModel {
    let titleNavigationBar = "My Account"
    
    func saveToFirebase(item: UserData) {
        let updatedData: [String: Any] = [
            "name": item.name ?? "",
            "phone": item.phone ?? ""
        ]
        
        FirebaseManager.shared.editUserDocument(uid: item.uid ?? "", updatedUserData: updatedData) { result in
            switch result {
            case .success:
                print("User data updated successfully")
            case .failure(let error):
                print("Error updating user data: \(error.localizedDescription)")
            }
        }

    }
}
