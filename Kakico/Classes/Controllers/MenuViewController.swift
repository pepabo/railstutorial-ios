import UIKit

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("hoge")
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