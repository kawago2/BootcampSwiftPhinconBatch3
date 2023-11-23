import UIKit
import FirebaseFirestore

enum PermissionType: String, CaseIterable {
    case sickLeave = "Sick Leave"
    case vacation = "Vacation"
}

enum PermissionStatus: String, CaseIterable {
    case submitted = "Submitted"
    case approved = "Approved"
    case rejected = "Rejected"
    case inProgress = "In Progress"
}

struct PermissionForm {
    var applicantID: String?
    var type: PermissionType?
    var submissionTime: Date?
    var permissionTime: Date?
    var approvalTime: Date?
    var status: PermissionStatus?
    var additionalInfo: AdditionalInfo?
    var comments: String?

    struct AdditionalInfo {
        var reason: String?
        var duration: String?
    }

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "applicantID": applicantID ?? "",
            "type": type?.rawValue ?? "",
            "submissionTime": submissionTime ?? FieldValue.serverTimestamp(),
            "permissionTime": permissionTime ?? FieldValue.serverTimestamp(),
            "status": status?.rawValue ?? "", 
            "comments": comments ?? ""
        ]

        if let approvalTime = approvalTime {
            dictionary["approvalTime"] = approvalTime
        }

        var additionalInfos: [String: Any] = [:]

        if let reason = additionalInfo?.reason, !reason.isEmpty {
            additionalInfos["reason"] = reason
        }

        if let duration = additionalInfo?.duration, !duration.isEmpty {
            additionalInfos["duration"] = duration
        }

        dictionary["additionalInfo"] = additionalInfos

        return dictionary
    }

    mutating func fromDictionary(dictionary: [String: Any]) {
        self.applicantID = dictionary["applicantID"] as? String
        self.type = PermissionType(rawValue: dictionary["type"] as? String ?? "")
        
        if let submissionTimeTimestamp = dictionary["submissionTime"] as? Timestamp {
            self.submissionTime = submissionTimeTimestamp.dateValue()
        } else {
            self.submissionTime = nil
        }

        if let permissionTimeTimestamp = dictionary["permissionTime"] as? Timestamp {
            self.permissionTime = permissionTimeTimestamp.dateValue()
        } else {
            self.permissionTime = nil
        }

        if let approvalTimeTimestamp = dictionary["approvalTime"] as? Timestamp {
            self.approvalTime = approvalTimeTimestamp.dateValue()
        } else {
            self.approvalTime = nil
        }

        self.status = PermissionStatus(rawValue: dictionary["status"] as? String ?? "")

        let additionalInfoDict = dictionary["additionalInfo"] as? [String: Any] ?? [:]
        self.additionalInfo = AdditionalInfo(
            reason: additionalInfoDict["reason"] as? String,
            duration: additionalInfoDict["duration"] as? String
        )

        self.comments = dictionary["comments"] as? String
    }
}
