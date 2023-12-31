import UIKit
import FloatingPanel

class CreateBudgetViewController: BaseViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var navigatorBar: NavigationBar!
    @IBOutlet weak var nameBudgetField: InputField!
    @IBOutlet weak var cycleBudgetField: InputField!
    @IBOutlet weak var accountField: InputField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    private var dropDownManager: DropDownManager!
    private var fpc: FloatingPanelController!
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
        cycleBudgetField.inputText.textColor = UIColor(named: ColorName.primary)
    }
    
    // MARK: - Event Setup
    
    private func setupEvent() {
        accountField.iconButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dropDownLogic()
        }).disposed(by: disposeBag)
        
        navigatorBar.leadingButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.backToView()
        }).disposed(by: disposeBag)
        
        cycleBudgetField.iconButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.setupFP()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - FloatingPanel Setup

    private func setupFP() {
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = self
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.appearance.cornerRadius = 20
        let contentVC = PickDateViewController()
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        present(fpc, animated: true, completion: nil)
    }
}

// MARK: - DropDown Setup

extension CreateBudgetViewController {
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
// MARK: - FloatingPanel Delegate and Layout

extension CreateBudgetViewController: FloatingPanelControllerDelegate, FloatingPanelLayout {

    var position: FloatingPanel.FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanel.FloatingPanelState {
        return .full
    }

    var anchors: [FloatingPanel.FloatingPanelState: FloatingPanel.FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .full: FloatingPanelLayoutAnchor(fractionalInset: 0.9, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full:
            return 0.3
        default:
            return 0.1
        }
    }
}

extension CreateBudgetViewController: PickDateViewDelegate {
    func passData(selectedDates: [Date]) {
        if selectedDates.count == 1 {
            cycleBudgetField.inputText.text = "Monthly"
            return
        }
        guard let firstSelectedDate = selectedDates.first else {
            cycleBudgetField.inputText.text = "No date selected"
            return
        }

        let weekNumber = getWeekNumber(for: firstSelectedDate)
        var setString = ""

        switch weekNumber {
        case 0:
            setString = "Weekly on 1st"
        case 1:
            setString = "Weekly on 2nd"
        case 2:
            setString = "Weekly on 3rd"
        default:
            setString = "Weekly on \(weekNumber+1)th"
        }

        cycleBudgetField.inputText.text = setString
    }

    
    private func getWeekNumber(for date: Date) -> Int {
        let calendar = Calendar(identifier: .iso8601)
        let weekOfYear = calendar.component(.weekOfMonth, from: date)
        return weekOfYear
    }
}
