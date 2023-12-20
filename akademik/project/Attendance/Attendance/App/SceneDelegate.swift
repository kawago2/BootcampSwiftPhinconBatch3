import UIKit
import RxSwift
import RxCocoa


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let disposeBag = DisposeBag()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Setup Initial View
        let window = UIWindow(windowScene: windowScene)
        let tabbar = TabBarViewController()
        let splash = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splash)
        
        // Checking Internet
        if NetworkManager.shared.isConnected {
            if FAuth.auth.currentUser != nil {
                navigationController.setViewControllers([tabbar], animated: true)
            }
        } else {
            showLoadingView()
        }
        
        // Setup network reachability observer
        observeNetworkReachability()
        
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func observeNetworkReachability() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let status = NetworkManager.shared.isConnected
            if status {
                self.dismissLoadingView() {
                    self.window?.rootViewController?.viewWillAppear(true)
                }
            }
            else {
                self.showLoadingView()
            }
        }
    }


    
    func showNoInternetAlert() {
        guard let topViewController = topViewController() else {
            return
        }
        
        let alertController = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        topViewController.present(alertController, animated: true, completion: nil)
    }
    
    private var loadingView: UIView?
    
    private func showLoadingView() {
          // Only show the loading view if it's not currently presented
          guard loadingView == nil else {
              return
          }

          // Create and show the loading view
          loadingView = createLoadingView()
          presentLoadingView()
      }
    
    private func createLoadingView() -> UIView {
        let loadingView = UIView(frame: window?.bounds ?? UIScreen.main.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        
        return loadingView
    }
    
    private func presentLoadingView() {
        guard let loadingView = loadingView else {
            return
        }
        
        topViewController()?.view.addSubview(loadingView)
    }
    
    private func dismissLoadingView(completion: (() -> Void)? = nil) {
        guard let loadingView = loadingView else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            loadingView.alpha = 0
        }) { _ in
            loadingView.removeFromSuperview()
            self.loadingView = nil
            completion?()
        }
    }
    
    
    func topViewController() -> UIViewController? {
        if var topController = window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

