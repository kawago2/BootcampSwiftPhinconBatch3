import UIKit
import RxSwift
import RxCocoa

class SplashViewModel {
    
    // MARK: - Properties
    
    private let navigateToNextSubject = PublishSubject<Void>()

    // MARK: - Outputs
    
    var navigateToNext: Observable<Void> {
        return navigateToNextSubject.asObservable()
    }

    // MARK: - Action
    
    func navigateToNextAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToNextSubject.onNext(())
        }
    }
}
