import UIKit
import KeychainAccess

class LoadViewController: UIViewController {
    // MARK: - View Events
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if logined() {
            autoLogin()
        } else {
            login()
        }
    }

    // MARK: - Helpers
    private func logined() -> Bool {
        var keychain = Keychain(service: "nehan.Kakico")
        return keychain["authToken"] != nil && keychain["userId"] != nil
    }

    private func autoLogin() {
        showNextView("FeedNavigationController")
    }

    private func login() {
        showNextView("LoginViewController")
    }

    private func showNextView(view: String) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(view) as! UIViewController
        viewController.modalTransitionStyle = .CrossDissolve
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}