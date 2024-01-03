import UIKit
import RxSwift
import RxCocoa

class SplashViewModel {
    
    // MARK: - Properties
    
    let navigateToNextSubject = PublishSubject<Void>()

    // MARK: - Action
    
    func navigateToNextAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToNextSubject.onNext(())
        }
    }
}
