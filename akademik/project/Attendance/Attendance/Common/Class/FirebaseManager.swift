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
    
    // MARK: - Function Firestore

    // MARK: - Function Firestore

    // MARK: - Function Firebase Storage

}

