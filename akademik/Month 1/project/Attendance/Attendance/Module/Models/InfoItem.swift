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
    let id: String?
    let startDate: Date?
    let endDate: Date?
    let position: String?
    let task: String?
    let status: Int?
}


struct ProfileItem {
    let nik: String?
    let alamat: String?
    let name: String?
    let posisi: String?
    var imageUrl: String?
}

