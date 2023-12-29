import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

enum CustomError: Error {
    case nilResult
    case nilDocumentData
    case customError(message: String)
}

class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {
        configureFirebase()
    }

    private func configureFirebase() {
        FirebaseApp.configure()
    }

    // MARK: - Declare Variable
    lazy var firestoreDB: Firestore = {
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()

    lazy var auth: Auth = {
        let auth = Auth.auth()
        return auth
    }()

    lazy var storage: Storage = {
        let storage = Storage.storage()
        return storage
    }()

    // MARK: - Function Authentification
    
    func isUserLoggedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func getCurrentUserUid() -> String? {
        guard let uid = auth.currentUser?.uid else {return nil}
        return uid
    }
    
    func getCurrentUserEmail() -> String? {
        guard let email = auth.currentUser?.email else {return nil}
        return email
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }


    func registerUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func updateDisplayName(newName: String, completion: @escaping (Result<Void, Error>) -> Void) {
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
            let error = NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
            completion(.failure(error))
        }
    }

    // MARK: - Function Firestore

    func setDocument(documentID: String, data: [String: Any], inCollection collection: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let documentRef = firestoreDB.collection(collection).document(documentID)

        documentRef.setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getDocument(collection:String, documentID: String, completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
        let documentRef = firestoreDB.collection(collection).document(documentID)
        
        documentRef.getDocument { (document, error) in
            if let document = document {
                completion(.success(document))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func editDocument(inCollection collection: String, documentIDToEdit: String, newData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func getDataFromSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, completion: @escaping (Result<[DocumentSnapshot], Error>) -> Void) {
        let db = Firestore.firestore()
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
    
    func addDataToSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection(collection).document(documentID)
        
        documentRef.collection(subcollectionPath).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func editDataInSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, documentIDToEdit: String, newData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func deleteDataFromSubcollection(documentID: String, inCollection collection: String, subcollectionPath: String, documentIDToDelete: String, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func addDataToSubcollectionWithAutoID(documentID: String, inCollection collection: String, subcollectionPath: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection(collection).document(documentID)
        let subcollectionRef = documentRef.collection(subcollectionPath)
        
        var dataWithAutoID = data
        let autoGeneratedID = subcollectionRef.document().documentID
        dataWithAutoID["autoGeneratedID"] = autoGeneratedID

        subcollectionRef.document(autoGeneratedID).setData(dataWithAutoID) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Function Firebase Storage

    func getImageURL(atPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
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
    
    func uploadImage(_ image: UIImage, toPath path: String, completion: @escaping (Result<String, Error>) -> Void) {
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
}
