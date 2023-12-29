//
//  AddFormViewModel.swift
//  Attendance
//
//  Created by Phincon on 28/12/23.
//

import Foundation
import RxSwift
import RxCocoa

class AddFormViewModel {
    // Inputs
    let position = BehaviorRelay<String>(value: "")
    let task = BehaviorRelay<String>(value: "")
    let startDate = BehaviorRelay<Date>(value: Date())
    let endDate = BehaviorRelay<Date>(value: Date())
    let status = BehaviorRelay<TaskStatus>(value: .inProgress)
    let addButtonTapped = PublishRelay<Void>()
    
    var statusCurrent: TaskStatus?
    var documentID: String?

    // Outputs
    let validationError = PublishSubject<ThrowError>()
    let itemSaved = PublishRelay<TimesheetItem>()

    private let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        addButtonTapped.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.validateAndSave()
        }).disposed(by: disposeBag)
    }

    private func validateAndSave() {
        do {
            try checkFields()
            let item = TimesheetItem(id: "", startDate: startDate.value, endDate: endDate.value, position: position.value, task: task.value, status: .completed)
            itemSaved.accept(item)
        } catch let error as ThrowError {
            validationError.onNext(error)
        } catch {
            fatalError("Unexpected error: \(error)")
        }
    }

    private func checkFields() throws {
        let isPositionEmpty = position.value.isEmpty
        let isTaskEmpty = task.value.isEmpty

        if isPositionEmpty && isTaskEmpty {
            throw ThrowError.allEmpty
        } else if isPositionEmpty {
            throw ThrowError.isPositionEmpty
        } else if isTaskEmpty {
            throw ThrowError.isTaskEmpty
        }
    }
}
