import UIKit

class BudgetViewController: BaseViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPopUpIfNeeded()
    }
    
    // MARK: - PopUp Logic
    
    private func showPopUpIfNeeded() {
        guard !UserDefaultsManager.shared.getFirstBudget() else {
            return
        }
        
        showPopUp(
            titleButton: "Create a New Budget",
            image: CustomImage.imageBudgetPop,
            getDefaultManager: UserDefaultsManager.shared.getFirstBudget(),
            setDefaultManager: {
                UserDefaultsManager.shared.setFirstBudget(false)
            }
        )
    }
    
}

// MARK: - PopUp Display

extension BudgetViewController: CustomPopUpViewDelegate {
    
    func showPopUp(titleButton: String, image: String, getDefaultManager: Bool, setDefaultManager: @escaping () -> Void) {
        guard !getDefaultManager else {
            return
        }
        
        let popUpVC = CustomPopUpViewController()
        popUpVC.configurePopUp(item: CustomPopUp(image: image, titleButton: titleButton))
        popUpVC.delegate = self
        popUpVC.modalTransitionStyle = .crossDissolve
        popUpVC.modalPresentationStyle = .overFullScreen
        
        present(popUpVC, animated: true) {
            setDefaultManager()
        }
    }
    
    func buttonLogic() {
        let createBudgetVC = CreateBudgetViewController()
        navigationController?.pushViewController(createBudgetVC, animated: true)
    }
}
