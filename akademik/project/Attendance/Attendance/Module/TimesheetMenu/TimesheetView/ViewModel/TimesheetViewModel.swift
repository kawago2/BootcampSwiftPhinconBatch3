//
//  TimesheetViewModel.swift
//  Attendance
//
//  Created by Phincon on 28/12/23.
//

import Foundation
import FirebaseFirestore

struct TimesheetItem {
    let id: String?
    let startDate: Date?
    let endDate: Date?
    let position: String?
    let task: String?
    let status: TaskStatus?
}

enum TaskStatus: String, CaseIterable {
    case completed = "Completed"
    case inProgress = "In Progress"
    case rejected = "Rejected"
}

class TimesheetViewModel {
    // MARK: - Properties

    var timesheetData: [TimesheetItem] = []
    var completedTimesheets: [TimesheetItem] = []
    var currentSortBy = ""

    // MARK: - Data Handling Methods

    func getData(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        timesheetData = []
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }

        let documentID = uid
        let collection = "users"
        let subcollectionPath = "timesheets"

        FirebaseManager.shared.getDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath) { result in
            switch result {
            case .success(let documents):
                for document in documents {
                    let id = document.documentID
                    if let data = document.data() {
                        let startDate = data["start_date"] as? Timestamp
                        let endDate = data["end_date"] as? Timestamp
                        let position = data["position"] as? String
                        let task = data["task"] as? String
                        let statusString = data["status"] as? String
                        let status = TaskStatus(rawValue: statusString ?? "")
                        let timesheetItem = TimesheetItem(id: id, startDate: startDate?.dateValue(), endDate: endDate?.dateValue(), position: position, task: task, status: status)
                        self.timesheetData.append(timesheetItem)
                    }
                }
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func deleteData(at index: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }

        let documentID = uid
        let collection = "users"
        let subcollectionPath = "timesheets"
        let deletedDocumentID = completedTimesheets[index].id ?? ""
        FirebaseManager.shared.deleteDataFromSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath, documentIDToDelete: deletedDocumentID) { result in
            switch result {
            case .success:
                completionHandler(.success(()))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func addData(item: TimesheetItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }
        let documentID = uid
        let collection = "users"
        let subcollectionPath = "timesheets"
        let dataToAdd: [String: Any] = [
            "start_date": item.startDate ?? Date(),
            "end_date": item.endDate ?? Date(),
            "position": item.position ?? "",
            "task": item.task ?? "",
            "status": item.status?.rawValue ?? ""
        ]

        FirebaseManager.shared.addDataToSubcollection(documentID: documentID, inCollection: collection, subcollectionPath: subcollectionPath, data: dataToAdd) { result in
            switch result {
            case .success:
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func editData(item: TimesheetItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = FirebaseManager.shared.getCurrentUserUid() else {
            return
        }

        let collection = "users"
        let subcollectionPath = "timesheets"
        let editedDocumentID = item.id ?? ""

        let dataToEdit: [String: Any] = [
            "start_date": item.startDate ?? Date(),
            "end_date": item.endDate ?? Date(),
            "position": item.position ?? "",
            "task": item.task ?? "",
            "status": item.status?.rawValue ?? ""
        ]

        FirebaseManager.shared.editDataInSubcollection(documentID: uid, inCollection: collection, subcollectionPath: subcollectionPath, documentIDToEdit: editedDocumentID, newData: dataToEdit) { result in
            switch result {
            case .success:
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    // MARK: - Sorting Methods

    func sortByStatus(sortby: String) {
        switch sortby {
        case TaskStatus.completed.rawValue.lowercased():
            completedTimesheets = timesheetData.filter { $0.status == .completed }
        case TaskStatus.inProgress.rawValue.lowercased():
            completedTimesheets = timesheetData.filter { $0.status == .inProgress }
        case TaskStatus.rejected.rawValue.lowercased():
            completedTimesheets = timesheetData.filter { $0.status == .rejected }
        default:
            completedTimesheets = timesheetData
        }
    }

    func sortByDate(sortby: String) {
        switch sortby {
        case DateSortOption.oldest.rawValue.lowercased():
            completedTimesheets = completedTimesheets.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
        case DateSortOption.newest.rawValue.lowercased():
            completedTimesheets = completedTimesheets.sorted { $0.startDate ?? Date() > $1.startDate ?? Date() }
        default:
            break
        }
    }
}
