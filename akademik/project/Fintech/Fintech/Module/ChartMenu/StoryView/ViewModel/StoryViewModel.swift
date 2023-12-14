import UIKit

// MARK: - Story Struct
struct Story {
    var username: String?
    var imageName: String?
    var backgroundColor: String?
}

// MARK: - StoryViewModel
class StoryViewModel {
    
    // MARK: - Properties
    let dummyStories: [Story] = [
        Story(imageName: "report0", backgroundColor: ColorName.accent1),
        Story(imageName: "report1", backgroundColor: ColorName.accent2),
        Story(imageName: "report2", backgroundColor: ColorName.accent3),
        Story(imageName: "report3", backgroundColor: ColorName.primary),
    ]
}
