//
//  SearchBar.swift
//  profileUI
//
//  Created by Phincon on 07/11/23.
//

import UIKit

class SearchBar: UIView {

    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var leadingButton: UIButton!
   
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .clear
        self.addSubview(view)
    }

    func setup(placeholder: String, isButtonHidden: Bool?) {
        textInput.placeholder = placeholder
        leadingButton.isHidden = isButtonHidden ?? false
        setupButton()
    }
    
    @objc func tapButton() {
    }
    
    func setupButton() {
        leadingButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
}
