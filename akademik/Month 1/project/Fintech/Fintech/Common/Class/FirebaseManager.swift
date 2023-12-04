import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

enum CustomError: Error {
    case nilResult
    case customError(message: String)
}


class FirebaseManager {
    
    // Singleton instance
    static let shared = FirebaseManager()
    
    private init() {
        configureFirebase()
    }
    
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    // Firestore Database
    lazy var firestoreDB: Firestore = {
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()
    
    // Authentication
    lazy var auth: Auth = {
        let auth = Auth.auth()
        return auth
    }()
    
    // Storage
    lazy var storage: Storage = {
        let storage = Storage.storage()
        return storage
    }()
    
    // Example function to fetch documents from Firestore
    func fetchDocumentsFromFirestore(completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
        firestoreDB.collection("yourCollection").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            completion(documents, nil)
        }
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            completion(Result {
                try {
                    if let error = error { throw error }
                    guard let authResult = authResult else { throw CustomError.nilResult }
                    return authResult
                }()
            })
        }
    }

    
    // Example function to upload a file to Firebase Storage
    func uploadFileToStorage(data: Data, path: String, completion: @escaping (StorageMetadata?, Error?) -> Void) {
        let storageRef = storage.reference().child(path)
        let metadata = StorageMetadata()
        
        storageRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(metadata, nil)
        }
    }
}

