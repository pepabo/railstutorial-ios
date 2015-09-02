import UIKit

class ConfigViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var userView = segue.destinationViewController as! UserViewController
        
        let type = segue.identifier!
        switch type {
            case "all":
                userView._listType = "all"
            case "followers":
                userView._listType = "followers"
            case "following":
                userView._listType = "following"
        default:
            println("undefined segue.identifier")
        }
    }
}
