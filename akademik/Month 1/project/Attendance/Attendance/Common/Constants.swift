import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Reachability

enum Icons {
    static let home = UIImage(systemName: "house")
    static let profile = UIImage(systemName: "person")
    static let history = UIImage(systemName: "clock")
    static let timesheet = UIImage(systemName: "book.closed")
    
}

enum Variables {
    static let optionArray = ["Completed", "In Progress", "Rejected"]
    static let dateSort = ["Ascendant","Descendant"]
}

enum FAuth {
    static let auth = Auth.auth()
    
    static func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                
                completion(.success(user))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    static func registerUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    static func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    static func updateDisplayName(newName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let user = auth.currentUser {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = newName
            
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } else {
            let error = NSError(domain: "FAuth", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
            completion(.failure(error))
        }
    }
    
    static func getCurrentUser(completion: @escaping (Result<User?, Error>) -> Void) {
        if let user = auth.currentUser {
            completion(.success(user))
        } else {
            let error = NSError(domain: "FAuth", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user is currently logged in."])
            completion(.failure(error))
        }
    }
    
    static func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
}

enum FFirestore {
    static let db = Firestore.firestore()
    
    static func getAllDocuments(collection: String, completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void) {
        let collectionRef = db.collection(collection)

        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error
                completion(.failure(error))
            } else {
                // Check if there are documents in the collection
                guard let documents = querySnapshot?.documents else {
                    // No documents found
                    completion(.success([]))
                    return
                }

                // Successfully retrieved documents
                completion(.success(documents))
            }
        }
    }

    
    static func getDocument(collection:String, documentID: String, completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
        let documentRef = db.collection(collection).document(documentID)
        
        documentRef.getDocument { (document, error) in
            if let document = document {
                completion(.success(document))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    static func addDocument(data: [String: Any], toCollection collection: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    static func setDocument(documentID: String, data: [String: Any], inCollection collection: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let documentRef = db.collection(collection).document(documentID)
        
        documentRef.setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    static func editDocument(inCollection collection: String, documentIDToEdit: String, newData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection(collection).document(documentIDToEdit)
        
        documentReference.updateData(newData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    static func addDataToSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let documentRef = db.collection(collection).document(documentID)
        
        documentRef.collection(subcollectionPath).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    static func getDataFromSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, completion: @escaping (Result<[DocumentSnapshot], Error>) -> Void) {
        let documentRef = db.collection(collection).document(documentID).collection(subcollectionPath)
        
        documentRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                let documents = querySnapshot.documents
                completion(.success(documents))
            }
        }
    }
    
    static func deleteDataFromSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, documentIDToDelete: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection(collection).document(documentID).collection(subcollectionPath).document(documentIDToDelete)
        
        documentReference.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    static func editDataInSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, documentIDToEdit: String, newData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection(collection).document(documentID).collection(subcollectionPath).document(documentIDToEdit)
        
        documentReference.updateData(newData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}


enum FStorage {
    static let storage = Storage.storage()
    
    static func uploadImage(_ image: UIImage, toPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child(path)
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain: "FStorage", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])
            completion(.failure(error))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url?.absoluteString else {
                    completion(.failure(error ?? NSError()))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Upload progress: \(percentComplete)%")
        }
        
        uploadTask.observe(.success) { snapshot in
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                completion(.failure(error))
            }
        }
    }
    
    static func getImage(atPath path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storageRef = storage.reference().child(path)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                let unknownError = NSError(domain: "FStorage", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image data."])
                completion(.failure(unknownError))
            }
        }
    }
    
    static func getImageURL(atPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child(path)
        
        storageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let downloadURL = url?.absoluteString {
                completion(.success(downloadURL))
            } else {
                let unknownError = NSError(domain: "FStorage", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image URL."])
                completion(.failure(unknownError))
            }
        }
    }
}

enum NetworkStatus {
    case connected, notConnected
    
    static func getStatus() -> NetworkStatus {
        guard let reachability = try? Reachability() else {
            return .notConnected
        }
        
        return reachability.connection != .unavailable ? .connected : .notConnected
    }
    
}
