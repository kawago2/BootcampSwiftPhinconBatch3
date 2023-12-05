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
    
    func isUserVerified() -> Bool {
        guard let currentUser = auth.currentUser else {return false}
        return currentUser.isEmailVerified
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            completion(Result {
                try {
                    if let error = error { throw error }
                    guard let authResult = authResult else { throw CustomError.nilResult }

                    if !authResult.user.isEmailVerified {
                        self.sendEmailVerification(completion: {_ in
                            self.signOut {_ in
                            }
                        })
                        throw CustomError.customError(message: "Email not verified. Please check your email and verify your account.")
                    }

                    return authResult
                }()
            })
        }
    }
    
    func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in."])))
            return
        }

        user.sendEmailVerification { error in
            completion(Result {
                if let error = error {
                    throw error
                }
            })
        }
    }

    func register(withEmail email: String, password: String, name: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            self.sendEmailVerification { verificationResult in
                switch verificationResult {
                case .success:
                    self.createUserDocument(uid: authResult!.user.uid, email: email, name: name) { userDocResult in
                        switch userDocResult {
                        case .success:
                            completion(.success(authResult!))

                        case .failure(let userDocError):
                            completion(.failure(userDocError))
                        }
                    }

                case .failure(let verificationError):
                    completion(.failure(verificationError))
                }
            }
        }
    }
    
    func forgotPassword(forEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    
    // MARK: - Function Firestore
    func createUserDocument(uid: String, email: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userDocumentData: [String: Any] = [
            "uid": uid,
            "email": email,
            "name": name
        ]

        firestoreDB.collection("users").document(uid).setData(userDocumentData) { error in
            completion(Result {
                if let error = error {
                    throw error
                }
            })
        }
    }
    
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

