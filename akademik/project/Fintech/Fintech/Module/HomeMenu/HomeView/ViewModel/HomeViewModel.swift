//
//  HomeViewModel.swift
//  Fintech
//
//  Created by Phincon on 19/12/23.
//

import Foundation

class HomeViewModel {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return 2
    }
    
    func getUserData(uid: String, completion: @escaping (Result<UserData?, Error>) -> Void) {
        FirebaseManager.shared.getUserDocument(uid: uid) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
