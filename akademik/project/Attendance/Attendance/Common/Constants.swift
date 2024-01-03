import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Reachability

enum Icons {
    static let home = UIImage(systemName: "house")
    static let profile = UIImage(systemName: "person")
    static let history = UIImage(systemName: "clock")
    static let timesheet = UIImage(systemName: "book.closed")
    static let circle = UIImage(systemName: "circle.fill")
    
}

enum Variables {
    static let dataArray = ["Date Permission", "Status"]
}

enum Image {
    static let notAvail = "image_not_available"
}

enum DateSortOption: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}
