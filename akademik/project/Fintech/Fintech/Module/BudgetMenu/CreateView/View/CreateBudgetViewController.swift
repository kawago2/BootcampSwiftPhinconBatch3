import UIKit

class CreateBudgetViewController: BaseViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var navigatorBar: NavigationBar!
    @IBOutlet weak var nameBudgetField: InputField!
    @IBOutlet weak var cycleBudgetField: InputField!
    @IBOutlet weak var accountField: InputField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    private var dropDownManager: DropDownManager!
    private let account = ["Bank BCA","Bank BNI"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownManager = DropDownManager()
        setupUI()
        setupEvent()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        navigatorBar.setupLeadingButton()
        nameBudgetField.setup(title: "Name of budget", placeholder: "Monthly Budget", isSecure: false)
        cycleBudgetField.setupWithLogo(title: "Cycle of budget", placeholder: "Pick a start date", icon: CustomIcon.calender)
        accountField.setupWithLogo(title: "Select an account", placeholder: "Select an account", icon: "chevron.down")
        continueButton.roundCorners(corners: .allCorners, cornerRadius: 20)
    }
    
    private func setupEvent() {
        accountField.iconButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.dropDownLogic()
        }).disposed(by: disposeBag)
        
        navigatorBar.leadingButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.backToView()
        }).disposed(by: disposeBag)
        
    }
    
    private func dropDownLogic() {
        self.updateCornerRadius()
        if dropDownManager.isShow {
            dropDownManager.dismissDropDown()
        } else {
            self.dropDownManager.showDropDown(from: self.accountField, dataSource: self.account) { (index, item) in
                self.accountField.inputText.text = item
                self.updateCornerRadius()
            }
        }
    }

    
    
    private func updateCornerRadius() {
        if dropDownManager.isShow {
            accountField.contentView.roundCorners(corners: [.allCorners], cornerRadius: 20)
        } else {
            accountField.contentView.roundCorners(corners: [.bottomLeft, .bottomRight], cornerRadius: 0)
            accountField.contentView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 20)
        }
    }
    
}
