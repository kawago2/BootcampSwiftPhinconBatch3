//
//  InputField.swift
//  profileUI
//
//  Created by Phincon on 31/10/23.
//

import UIKit

@IBDesignable
class InputField: UIView {

    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var inputText: UITextField!
    
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
        errorField.text = ""
        self.addSubview(view)
    }

    func setup(title: String, placeholder: String) {
        titleField.text = title
        inputText.placeholder = placeholder
    }

}
