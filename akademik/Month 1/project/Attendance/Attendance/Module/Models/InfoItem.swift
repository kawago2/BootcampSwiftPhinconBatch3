import UIKit

struct InfoItem {
    let title: String?
    let description: String?
    let imageName: String?
}


struct HistoryItem {
    let checkTime: Date?
    let descLocation: String?
    let image: String?
    let isCheck: Bool?
    let titleLocation: String?
}

struct TimesheetItem {
    let startDate: Date?
    let endDate: Date?
    let position: String?
    let task: String?
}