import UIKit
import Alamofire
import SwiftyJSON

class UserViewController: UITableViewController {
    // MARK: - Properties
    var users = UserDataManager()
    var _listType = ""
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request(_listType)
    }
    
    func request(listType: String) {
        self.navigationItem.title = listType
        
        switch listType {
        case "All":
            Alamofire.request(Router.GetAllUsers()).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        case "Followers":
            Alamofire.request(Router.GetFollowers(userId: 1)).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        case "Following":
            Alamofire.request(Router.GetFollowing(userId: 1)).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        default:
            println("undefined segue.identifier in UserViewController")
        }
    }
    
    func setUserList(data: AnyObject?) {
        println(data)
        if data != nil {
            let json = JSON(data!)
            println(json)
            
            for (index: String, subJson: JSON) in json["contents"] {
                var user: User = User(
                    id: subJson["id"].int!,
                    name: subJson["name"].string!,
                    icon: NSURL(string: "")!
                )
                self.users.set(user)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView!.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.size
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserTableViewCell
        let user = self.users[indexPath.row] as User
        cell.userName.text = user.name
        cell.userIcon.imageView?.sd_setImageWithURL(user.icon)
        cell.tag = user.id
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var profileView = segue.destinationViewController as! ProfileViewController

        profileView._userId = 1
    }
}
