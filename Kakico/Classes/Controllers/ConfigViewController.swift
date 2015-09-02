import UIKit

class ConfigViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var userView = segue.destinationViewController as! UserViewController
        
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