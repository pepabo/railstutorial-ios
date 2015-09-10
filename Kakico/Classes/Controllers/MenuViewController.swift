import UIKit
import KeychainAccess

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func removeKeychain() {
        var keychain = Keychain(service: "nehan.Kakico")
        keychain["authToken"] = nil
        keychain["userId"] = nil
        println("---------- keychain info ----------")
        println(keychain["authToken"])
        println(keychain["userId"])
        println("---------- keychain info ----------")
    }

    func moveToLoginView() {
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        loginView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(loginView, animated: true, completion: nil)
    }

    func logout() {
        removeKeychain()
        moveToLoginView()
        println("Log out complete...")
    }

    func selectAlert() {
        let alertController = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .ActionSheet)
        let logoutAction = UIAlertAction(title: "Log out", style: .Default) {
            action in self.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in println("Cancel")
        }

        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            selectAlert()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let userView = segue.destinationViewController as? UserViewController {
            let type = segue.identifier!
            switch type {
            case "All":
                userView._listType = "All"
            case "Followers":
                userView._listType = "Followers"
            case "Following":
                userView._listType = "Following"
            default:
                println("undefined segue.identifier in ConfigViewController")
            }
        }
    }
}