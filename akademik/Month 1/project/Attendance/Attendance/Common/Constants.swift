import Foundation
import UIKit
import FirebaseAuth

enum Icons {
    static let home = UIImage(systemName: "house")
    static let profile = UIImage(systemName: "person.fill")
    static let history = UIImage(systemName: "clock")
}

enum FAuth {
    static let auth = Auth.auth()
    
    // MARK: - Authentication
    
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
}
