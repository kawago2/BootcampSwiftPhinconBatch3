import UIKit
import RxSwift
import RxCocoa

class SplashViewModel {
    private let navigateToNextSubject = PublishSubject<Void>()

    var navigateToNext: Observable<Void> {
        return navigateToNextSubject.asObservable()
    }

    func navigateToNextAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToNextSubject.onNext(())
        }
    }
}
