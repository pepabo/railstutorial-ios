import UIKit
import KeychainAccess

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func logout() {
        var keychain = Keychain(service: "nehan.Kakico")
        keychain["authToken"] = nil
        keychain["userId"] = nil
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
        }else if segue.identifier == "Logout" {
            logout()
        }
    }
}