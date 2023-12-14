import UIKit

class BudgetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPopUp(titleButton: "Create a New Budget", image: CustomImage.imageBudgetPop, getDefaultManager: UserDefaultsManager.shared.getFirstBudget(), setDefaultManager: {
            UserDefaultsManager.shared.setFirstBudget(false)
        })
    }
}

// MARK: - Setup PopUp
extension BudgetViewController: CustomPopUpViewDelegate {
    func showPopUp(titleButton: String, image: String, getDefaultManager: Bool, setDefaultManager: @escaping () -> Void) {
        guard !getDefaultManager else {
            return
        }

        let vc = CustomPopUpViewController()
        vc.configurePopUp(item: CustomPopUp(image: image, titleButton: titleButton))
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true) {
            setDefaultManager()
        }
    }

    func buttonLogic() {
        
    }
}

