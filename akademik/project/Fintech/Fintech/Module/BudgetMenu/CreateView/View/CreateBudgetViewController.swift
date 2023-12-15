import UIKit

class CreateBudgetViewController: UIViewController {
    
    @IBOutlet weak var nameBudgetField: InputField!
    @IBOutlet weak var cycleBudgetField: InputField!
    @IBOutlet weak var accountField: InputField!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        nameBudgetField.setup(title: "Name of budget", placeholder: "Monthly Budget", isSecure: false)
        cycleBudgetField.setupWithLogo(title: "Cycle of budget", placeholder: "Pick a start date", icon: CustomIcon.calender)
        accountField.setupWithLogo(title: "Select an account", placeholder: "Select an account", icon: "chevron.down")
        continueButton.roundCorners(corners: .allCorners, cornerRadius: 20)
    }


}
