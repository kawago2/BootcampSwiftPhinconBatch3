//
//  HistoryViewModel.swift
//  Attendance
//
//  Created by Phincon on 28/12/23.
//

import Foundation
import FirebaseFirestore
import RxSwift

struct HistoryItem {
    let checkTime: Date?
    let descLocation: String?
    let image: String?
    let isCheck: Bool?
    let titleLocation: String?
}

class HistoryViewModel {
    var allData: [InfoItem] = []
    var allDataHistory: [HistoryItem] = []
    var filteredData: [HistoryItem] = []
    
    let showAlert = PublishSubject<(String, String)>()
    let emptyViewHidden = PublishSubject<Bool>()
    
    
    func getData(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        allData = []
        allDataHistory = []
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            self.showAlert.onNext(("Error", "User not Login !!"))
            return
        }
        
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "history"
        
        FirebaseManager.shared.getDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath) { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    if let data = document.data() {
                        let date = data["checkTime"] as? Timestamp
                        let isCheck = data["isCheck"] as? Bool ?? false
                        let title = data["titleLocation"] as? String ?? "DefaultTitle"
                        let description = data["descLocation"] as? String ?? "DefaultDescription"
                        let imageName = data["image"] as? String ?? "DefaultImage"
                        
                        let checkString = isCheck ? "Check In" : "Check Out"
                        
                        let formattedTime = date?.dateValue().formattedFullDateString() ?? Date().formattedFullDateString()


                        let infoItem = InfoItem(title: "\(checkString) - \(title) - \(formattedTime)", description: description, imageName: imageName)
                        let historyItem = HistoryItem(checkTime: date?.dateValue(), descLocation: description, image: imageName, isCheck: isCheck, titleLocation: title)
                        
                        
                        self.allData.append(infoItem)
                        self.allDataHistory.append(historyItem)
                    }
                }
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func filterData(by component: Calendar.Component) {
        filteredData = []
        
        var setCalendar = Calendar.current
        setCalendar.timeZone = .gmt
        let calendar = setCalendar
        let currentDate = Date()

        var startDate: Date
        var endDate: Date

        switch component {
        case .day:
            startDate = calendar.startOfDay(for: currentDate)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate) ?? currentDate
        case .weekOfYear:
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
                return
            }
            startDate = startOfWeek
            endDate = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? currentDate
        case .month:
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
                return
            }
            startDate = startOfMonth
            endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? currentDate
        case .year:
            guard let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: currentDate)) else {
                return
            }
            startDate = startOfYear
            endDate = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear) ?? currentDate
        default:
            return
        }
        
        filteredData = allDataHistory.filter { item in
            guard let checkTime = item.checkTime else {
                return false
            }
            let checker = checkTime >= startDate && checkTime <= endDate
            return checker
        }
        
        filteredData = filteredData.sorted { $0.checkTime ?? Date() > $1.checkTime ?? Date() }
        emptyViewHidden.onNext(filteredData.isEmpty)
    }

}
