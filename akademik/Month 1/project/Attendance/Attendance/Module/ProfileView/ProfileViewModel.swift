//import UIKit
//import RxSwift
//import RxCocoa
//
//class ProfileViewModel {
//    var profile: ProfileItem? {
//        didSet {
//            profileChanged?()
//        }
//    }
//    var profileChanged: (() -> Void)?
//    var profileArray: [InfoItem] = []
//
//    func loadData(completion: @escaping () -> Void) {
//        guard let uid = FAuth.auth.currentUser?.uid else {
//            return
//        }
//        
//        let collection = "users"
//        let documentID = uid
//        
//        FFirestore.getDocument(collection: collection, documentID: documentID) { result in
//            switch result {
//            case .success(let document):
//                if let profileData = document.data()?["profile"] as? [String: Any] {
//                    let nik = profileData["nik"] as? String ?? "Not set"
//                    let alamat = profileData["alamat"] as? String ?? "Not set"
//                    let name = profileData["name"] as? String ?? "Not set"
//                    let posisi = profileData["posisi"] as? String ?? "Not set"
//                    
//                    
//                    self.profile = ProfileItem(nik: nik, alamat: alamat, name: name, posisi: posisi)
//
//                    
//                    self.profileArray = [
//                        InfoItem(title: "No. Karyawan", description: nik, imageName: "identity"),
//                        InfoItem(title: "Alamat", description: alamat, imageName: "address"),
//                        InfoItem(title: "Change Password", description: "***************", imageName: "password")
//                    ]
//                    self.tableView.reloadData()
//                } else {
//                    self.profileArray = [
//                        InfoItem(title: "No. Karyawan", description: self.nik, imageName: "identity"),
//                        InfoItem(title: "Alamat", description: self.alamat, imageName: "address"),
//                        InfoItem(title: "Change Password", description: "***************", imageName: "password")
//                    ]
//                    self.tableView.reloadData()
//                }
//
//                completion()
//
//            case .failure(let error):
//                print("Error fetching user profile from Firestore: \(error.localizedDescription)")
//            }
//        }
//        
//        let imagePath = "images/profile-\(uid)"
//        FStorage.getImageURL(atPath: imagePath) { result in
//            switch result {
//            case .success(let imageURL):
//                if let url = URL(string: imageURL) {
//                    self.profileImage.kf.setImage(with: url)
//                    self.imageUrl = imageURL
//                } else {
//                    print("Invalid URL")
//                }
//            case .failure(let error):
//                print("Error retrieving image URL: \(error.localizedDescription)")
//                self.profileImage.image = UIImage(named: "image_not_available")
//            }
//        }
//        completion()
//    }
//
//    func editProfile(item: ProfileItem, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
//        // Your existing code for updating profile data and uploading image
//        // ...
//
//        completion(.success(()))
//    }
//}
