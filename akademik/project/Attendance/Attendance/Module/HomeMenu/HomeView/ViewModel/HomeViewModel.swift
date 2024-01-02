//
//  HomeViewModel.swift
//  Attendance
//
//  Created by Phincon on 29/12/23.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    var locationArray: [InfoItem] = []

    
    var locationSelected: InfoItem?
    var isCheckIn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var timer: Timer?
    var selectedCell = 0
    var currentDate = Date()
    var isValidator = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        locationArray = [
            InfoItem(title: "PT. Phincon", description: "Office. 88 @Kasablanka Office Tower 18th Floor", imageName: "id_1"),
            InfoItem(title: "Telkomsel Smart Office", description: "Jl. Jend. Gatot Subroto Kav. 52. Jakarta Selatan", imageName: "id_2"),
            InfoItem(title: "Rumah", description: "Jakarta", imageName: "id_3")
        ]
    }
    
    func checkToggle() {
        isCheckIn.accept(!isCheckIn.value)
    }
    
    func addDataToFirebase(completionHandler: @escaping (Result<Void, Error>) -> Void?) {
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }
        
        let check = isCheckIn.value
        let currentCell = self.selectedCell
        let collection =  "users"
        let documentID = uid
        
        let dataToSet: [String: Any] = [
            "is_check": check as Bool,
            "uid": uid as String,
            "active_page": currentCell as Int,
        ]

        FirebaseManager.shared.editDocument(inCollection: collection, documentIDToEdit: documentID, newData: dataToSet) { result in
            switch result {
            case .success:
                let subcollectionPath = "history"
                let dataToAdd: [String: Any] = [
                    "checkTime": self.currentDate ,
                    "descLocation": self.locationArray[currentCell].description ?? "",
                    "titleLocation": self.locationArray[currentCell].title ?? "",
                    "image": self.locationArray[currentCell].imageName ?? "",
                    "isCheck": self.isCheckIn.value,
                ]

                FirebaseManager.shared.addDataToSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath, data: dataToAdd) { result in
                    switch result {
                    case .success:
                        completionHandler(.success(()))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getData(completionHandler: @escaping (Result<Void, Error>) -> Void?) {
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }
        
        let documentID = uid
        let collection = "users"
        
        FirebaseManager.shared.getDocument(collection: collection,documentID: documentID) { result in
            switch result {
            case .success(let documentSnapshot):
                let data = documentSnapshot.data()
                if let currentData = data {
                    if let isCheckIn = currentData["is_check"] as? Bool,
                       let activePage = currentData["active_page"] as? Int{
                        if let isValidator = currentData["isValidator"] as? Bool {
                            self.isValidator = isValidator
                        } else {
                            self.isValidator = false
                        }
                        self.isCheckIn.accept(isCheckIn)
                        self.selectedCell = activePage
                        self.locationSelected = self.locationArray[activePage]
                        
                        
                    }
                }
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
