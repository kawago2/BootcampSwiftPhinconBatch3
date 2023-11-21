import UIKit

// Buat SplashViewModel
class SplashViewModel {
    func navigateToNextAfterDelay(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Panggil completion handler setelah delay
            completion()
        }
    }
}
