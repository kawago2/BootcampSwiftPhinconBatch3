import Foundation

enum TaskError: Error, LocalizedError {
    case oddNumber
}

func performTask(
    value: Int,
    onSuccess: () -> Void,
    onProgress: () -> Void,
    onFailure: (Error) -> Void
) {
    if value % 2 == 0 {
        onSuccess()
    } else {
        onFailure(TaskError.oddNumber)
    }
}

// Usage example:
performTask(value: 4, onSuccess: {
    print("Task succeeded")
}, onProgress: {
    print("Task is in progress")
}, onFailure: { error in
    print("Task failed with error: \(error.localizedDescription)")
})


