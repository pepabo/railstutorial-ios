import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess
import UIScrollView_InfiniteScroll

class UserViewController: UITableViewController {
    // MARK: - Properties
    var users = UserDataManager()
    var currentUserId = 0
    var _listType = ""
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request(_listType, page: 1)

        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            if (self.users.nextPage != nil) {
                self.request(self._listType, page: self.users.nextPage!)
            }
            
            self.tableView.reloadData()
            
            tableView.finishInfiniteScroll()
        }
    }

    @IBAction func toggleFollow(sender: UIButton) {
        if sender.titleLabel?.text == "Follow" {
            follow(sender.tag)
            followButtonStyle(sender)
        }else {
            unfollow(sender.tag)
            unfollowButtonStyle(sender)
        }
    }

    func request(listType: String) {
        self.navigationItem.title = listType

        let keychain = Keychain(service: "nehan.Kakico")
        if let id = keychain["userId"] {
            currentUserId = id.toInt()!
        }
        
        let params = [
            "page": String(page)
        ]

        switch listType {
        case "All":
            Alamofire.request(Router.GetAllUsers(params: params)).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        case "Followers":
            Alamofire.request(Router.GetFollowers(userId: currentUserId)).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        case "Following":
            Alamofire.request(Router.GetFollowing(userId: currentUserId)).responseJSON { (request, response, data, error) -> Void in
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
                    icon: NSURL(string: subJson["icon_url"].stringValue)!,
                    followingFlag: subJson["following_flag"].bool!
                )
                self.users.set(user)
            }

            self.users.nextPage = json["next_page"].intValue

            dispatch_async(dispatch_get_main_queue(), {
                self.tableView!.reloadData()
            })

        }
    }

    func follow(followedId: Int) {
        Alamofire.request(Router.PostRelationships(followedId: followedId))
    }

    func unfollow(followedId: Int) {
        Alamofire.request(Router.DeleteRelationships(followedId: followedId))
    }

    func initFollowButton(button: UIButton, user: User) {
        button.hidden = false
        button.tag = user.id

        if user.id == currentUserId {
            button.hidden = true
        }else if user.followingFlag {
            followButtonStyle(button)
        }else {
            unfollowButtonStyle(button)
        }
    }

    func followButtonStyle(button: UIButton) {
        button.setTitle("Unfollow", forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
    }

    func unfollowButtonStyle(button: UIButton) {
        button.setTitle("Follow", forState: .Normal)
        button.setTitleColor(UIColor.DefaultColor(), forState: .Normal)
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
        cell.userIcon.sd_setImageWithURL(user.icon)
        initFollowButton(cell.followButton, user: user)
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ProfileView" {
            var profileView: ProfileViewController = segue.destinationViewController as! ProfileViewController

            let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
            let user = self.users[indexPath.row] as User
            profileView._selectUserId = user.id
        }
    }
}
