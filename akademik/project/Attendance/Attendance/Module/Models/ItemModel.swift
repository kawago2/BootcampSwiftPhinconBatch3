import UIKit

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
    let status: TaskStatus?
}

enum DateSortOption: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}

enum TaskStatus: String, CaseIterable {
    case completed = "Completed"
    case inProgress = "In Progress"
    case rejected = "Rejected"
}


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


