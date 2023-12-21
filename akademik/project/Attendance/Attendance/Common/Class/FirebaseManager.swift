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

    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
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

    // MARK: - Function Firebase Storage

    // Add your Firebase Storage-related functions here
}
