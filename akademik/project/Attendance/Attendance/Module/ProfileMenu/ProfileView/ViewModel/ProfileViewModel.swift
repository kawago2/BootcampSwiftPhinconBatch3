import Foundation
import RxSwift
import RxCocoa

// MARK: - Model
struct InfoItem {
    let title: String?
    let description: String?
    let imageName: String?
}

struct ProfileItem {
    var nik: String?
    var alamat: String?
    var name: String?
    var posisi: String?
    var imageUrl: String?
}

class ProfileViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    let signoutButtonTap = PublishSubject<Void>()
    let pencilButtonTap = PublishSubject<Void>()
    let dollarButtonTap = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    let showAlert = PublishSubject<(String, String)>()
    let navigateToLoad = PublishSubject<Void>()
    let navigateToEditProfile = PublishSubject<Void>()
    let navigateToPayroll = PublishSubject<Void>()
    let navigateToLogin = PublishSubject<Void>()
    let updateProfileImage = PublishSubject<URL>()
    
    internal var profileData = ProfileItem()
    internal var profileArray: [InfoItem] = []
    
    init() {
        setupBindings()
        
    }
    
    private func setupBindings() {
        signoutButtonTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.signoutTapped()
            })
            .disposed(by: disposeBag)
        
        pencilButtonTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigateToEditProfile.onNext(())
            })
            .disposed(by: disposeBag)
        
        dollarButtonTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigateToPayroll.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Business Logic
    
    func signoutTapped() {
        FirebaseManager.shared.logout { result in
            switch result {
            case .success:
                self.navigateToLogin.onNext(())
            case .failure(let error):
                self.showAlert.onNext(("Error", "Logout failed. \(error.localizedDescription)"))
            }
        }
    }
    
    func loadDataGeneral(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }

        let collection = "users"
        let documentID = uid

        FirebaseManager.shared.getDocument(collection: collection, documentID: documentID) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let document):
                if let profileData = document.data()?["profile"] as? [String: Any] {
                    let nik = profileData["nik"] as? String ?? "Not set"
                    let alamat = profileData["alamat"] as? String ?? "Not set"
                    let name = profileData["name"] as? String ?? "Not set"
                    let posisi = profileData["posisi"] as? String ?? "Not set"

                    self.profileData = ProfileItem(nik: nik, alamat: alamat, name: name, posisi: posisi)

                    self.profileArray = [
                        InfoItem(title: "No. Karyawan", description: nik, imageName: "identity"),
                        InfoItem(title: "Alamat", description: alamat, imageName: "address"),
                        InfoItem(title: "Change Password", description: "***************", imageName: "password")
                    ]
                } else {
                    // Use the default values if profile data is not present
                    self.profileArray = [
                        InfoItem(title: "No. Karyawan", description: self.profileData.nik, imageName: "identity"),
                        InfoItem(title: "Alamat", description: self.profileData.alamat, imageName: "address"),
                        InfoItem(title: "Change Password", description: "***************", imageName: "password")
                    ]
                }
            case .failure(let error):
                // Call the completion handler with the error from Firebase
                completionHandler(.failure(error))
            }
        }

        let imagePath = "images/profile-\(uid)"
        FirebaseManager.shared.getImageURL(atPath: imagePath) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let imageURL):
                if let url = URL(string: imageURL) {
                    self.updateProfileImage.onNext(url)

                    // Update the profile image URL
                    self.profileData.imageUrl = imageURL
                    completionHandler(.success(()))
                }
            case .failure(let error):
                // Call the completion handler with the error from Firebase
                completionHandler(.failure(error))
            }
        }
    }

    
    func editProfile(item: ProfileItem, image: UIImage?) {
        guard
            let nik = item.nik,
            let alamat = item.alamat,
            let name = item.name,
            let posisi = item.posisi
        else {
            return showAlert.onNext(("Invalid Field", "Please fill all field"))
        }
        
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }
        
        let collection = "users"
        let documentID = uid
        
        let oldData = [
            "profile.nik": profileData.nik,
            "profile.alamat": profileData.alamat,
            "profile.name": profileData.name,
            "profile.posisi": profileData.posisi
        ]
        
        let updatedData = [
            "profile.nik": nik,
            "profile.alamat": alamat,
            "profile.name": name,
            "profile.posisi": posisi
        ]
        
        let dispatchGroup = DispatchGroup()
        
        
        
        if oldData != updatedData {
            dispatchGroup.enter()
            FirebaseManager.shared.editDocument(inCollection: collection, documentIDToEdit: documentID, newData: updatedData) { result in
                switch result {
                case .success:
                    dispatchGroup.leave()
                case .failure(let error):
                    self.showAlert.onNext(("Error", error.localizedDescription))
                }
            }
        }
        
        if let imageToUpload = image {
            let storagePath = "images/profile-\(uid)"
            dispatchGroup.enter()
            FirebaseManager.shared.uploadImage(imageToUpload, toPath: storagePath) { result in
                switch result {
                case .success(_):
                    dispatchGroup.leave()
                case .failure(let error):
                    self.showAlert.onNext(("Error", error.localizedDescription))
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.showAlert.onNext(( "Success", "Profile updated successfully"))
        }
    }
    
    func resetPassword() {
        if let userEmail = FirebaseManager.shared.getCurrentUserEmail() {
            FirebaseManager.shared.resetPassword(email: userEmail) { result in
                switch result {
                case .success:
                    self.showAlert.onNext(("Success", "Password reset email sent successfully\nPlease Check your email."))
                case .failure(let error):
                    self.showAlert.onNext((title: "Error", message: "Failed to reset password. \(error.localizedDescription)"))
                }
            }
        } else {
            self.showAlert.onNext(("Error", "User email is not available."))
        }
    }
}

