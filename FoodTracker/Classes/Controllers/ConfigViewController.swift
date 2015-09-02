import UIKit

class ConfigViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var userView = segue.destinationViewController as! UserViewController
        
        let type = segue.identifier
        if type == "all" {
            userView._listType = "all"
        }else if type == "followers" {
            userView._listType = "followers"
        }else if type == "following" {
            userView._listType = "following"
        }
    }
}
