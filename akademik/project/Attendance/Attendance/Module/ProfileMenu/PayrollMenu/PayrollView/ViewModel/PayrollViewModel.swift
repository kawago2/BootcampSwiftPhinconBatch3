//
//  PayrollViewModel.swift
//  Attendance
//
//  Created by Phincon on 28/12/23.
//

import Foundation
import FirebaseFirestore
import RxSwift

struct Allowance {
    var name: String
    var amount: Float
}

struct Deduction {
    var name: String
    var amount: Float
}

struct Payroll {
    var payrollId: String?
    var date: Date?
    var basicSalary: Float?
    var allowances: [Allowance]?
    var deductions: [Deduction]?
    var netSalary: Float?
}

class PayrollViewModel {
    
    // MARK: - Properties
    
    var dataPayroll: [Payroll] = []
    var filtereddataPayroll: [Payroll] = []
    var currentSortBy = ""
    
    let showAlert = PublishSubject<(String, String)>()
    
    // MARK: - Public Methods
    
    func getData(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        dataPayroll = []
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            showAlert.onNext(("Error", "User not login !!"))
            return
        }
        
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "payroll"
        
        FirebaseManager.shared.getDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath) { result in
            switch result {
            case .success(let documents):
                let dispatchGroup = DispatchGroup()
                
                for document in documents {
                    if let data = document.data() {
                        let id = data["payrollId"] as? String
                        let basicSalary = data["basicSalary"] as? Float
                        let date = data["date"] as? Timestamp
                        
                        var allowances: [Allowance] = []
                        var deductions: [Deduction] = []
                        
                        // Enter the dispatch group for 'allowances'
                        dispatchGroup.enter()
                        document.reference.collection("allowances").getDocuments { (querySnapshot, error) in
                            defer {
                                dispatchGroup.leave()
                            }
                            
                            if let error = error {
                                self.showAlert.onNext(("Error", error.localizedDescription))
                            } else if let querySnapshot = querySnapshot {
                                let documents = querySnapshot.documents
                                for doc in documents {
                                    let data = doc.data()
                                    let name = data["name"] as? String
                                    let value = data["value"] as? Float
                                    
                                    let item = Allowance(name: name ?? "", amount: value ?? 0.0)
                                    allowances.append(item)
                                }
                            }
                        }
                        
                        // Enter the dispatch group for 'deductions'
                        dispatchGroup.enter()
                        document.reference.collection("deductions").getDocuments { (querySnapshot, error) in
                            defer {
                                dispatchGroup.leave()
                            }
                            
                            if let error = error {
                                self.showAlert.onNext(("Error", error.localizedDescription))
                            } else if let querySnapshot = querySnapshot {
                                let documents = querySnapshot.documents
                                for doc in documents {
                                    let data = doc.data()
                                    let name = data["name"] as? String
                                    let value = data["value"] as? Float
                                    
                                    let item = Deduction(name: name ?? "", amount: value ?? 0.0)
                                    deductions.append(item)
                                }
                            }
                        }
                        
                        // Notify when both 'allowances' and 'deductions' have been fetched
                        dispatchGroup.notify(queue: .main) {
                            let netSalary = data["netSalary"] as? Float
                            
                            let itemPayroll = Payroll(
                                payrollId: id ?? "",
                                date: date?.dateValue() ?? Date(),
                                basicSalary: basicSalary ?? 0.0,
                                allowances: allowances,
                                deductions: deductions,
                                netSalary: netSalary ?? 0.0
                            )
                            self.dataPayroll.append(itemPayroll)
                            completionHandler(.success(()))
                        }
                    }
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
}
