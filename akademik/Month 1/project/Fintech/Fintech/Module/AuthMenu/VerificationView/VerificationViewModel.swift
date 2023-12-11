import UIKit
import RxRelay
import RxSwift


class VerificationViewModel {    
    func openMailAction() -> URL? {
        guard let mailURL = URL(string: Constants.mailURL) else {
            return nil
        }
        return mailURL
    }
}

extension VerificationViewModel {
    private enum Constants {
        static let mailURL = "https://mail.google.com/"
    }
}
