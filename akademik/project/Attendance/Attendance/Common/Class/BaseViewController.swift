//
//  BaseViewController.swift
//  Attendance
//
//  Created by Phincon on 20/12/23.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    public let disposeBag = DisposeBag()
    public let loadingViewController = LoadingViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func showLoading(isHidden: Bool) {
        if isHidden {
            self.dismiss(animated: true)
        } else {
            let vc = loadingViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
