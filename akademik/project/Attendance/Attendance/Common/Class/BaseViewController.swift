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
    private let loadingView = CustomLoading()
    public let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
    }

    private func setupLoading() {
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }

        hideLoading()
    }
    
    public func dismissView() {
        dismiss(animated: true)
    }
    
    public func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    public func showLoading() {
        // Show the loading view
        loadingView.show()
    }

    public func hideLoading() {
        // Hide the loading view
        loadingView.hide()
    }
}
