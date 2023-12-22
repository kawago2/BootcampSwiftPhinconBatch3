//
//  EditProfileViewModel.swift
//  Attendance
//
//  Created by Phincon on 22/12/23.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - View Model
class EditProfileViewModel {
    let image = BehaviorRelay<UIImage?>(value: nil)
    let profile = BehaviorRelay<ProfileItem?>(value: nil)
}
