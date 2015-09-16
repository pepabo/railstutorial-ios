import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import KeychainAccess
import UIScrollView_InfiniteScroll

class UserViewController: UITableViewController {
    // MARK: - Properties
    var users = UserDataManager()
    var myId = 0
    var _selectedId = 0
    var _listType = ""

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        resetSeparatorStyle()
        SVProgressHUD.showWithMaskType(.Black)
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        resetSeparatorStyle()
        SVProgressHUD.dismiss()
    }

    @IBAction func toggleFollow(sender: followButton) {
        if sender.isFollowing() {
            follow(sender.tag)
            sender.unfollowstyle()
        }else {
            showUnfollowingAlert(sender)
        }
    }

    func request(listType: String, page: Int) {
        self.navigationItem.title = listType

        let keychain = Keychain(service: "nehan.Kakico")
        if let id = keychain["userId"] {
            myId = id.toInt()!
        }

        if _selectedId == 0 {
            _selectedId = myId
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
            Alamofire.request(Router.GetFollowers(userId: _selectedId, params: params)).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        case "Following":
            Alamofire.request(Router.GetFollowing(userId: _selectedId, params: params)).responseJSON { (request, response, data, error) -> Void in
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
                var user = User(data: subJson)
                self.users.set(user)
            }

            self.users.nextPage = json["next_page"].intValue

            dispatch_async(dispatch_get_main_queue(), {
                self.tableView!.reloadData()
            })

        }
    }

    func showUnfollowingAlert(button: followButton) {
        let alertController = UIAlertController(title: "Are you sure you want to unfollow?", message: "", preferredStyle: .ActionSheet)
        let unfollowAction = UIAlertAction(title: "Unfollow", style: .Default, handler:{ (action:UIAlertAction!) -> Void in
            self.unfollow(button.tag)
            button.followstyle()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in println("Unfollow canceled")
        }

        alertController.addAction(unfollowAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func follow(followedId: Int) {
        Alamofire.request(Router.PostRelationships(followedId: followedId))
    }

    func unfollow(followedId: Int) {
        Alamofire.request(Router.DeleteRelationships(followedId: followedId))
    }

    func initFollowButton(button: followButton, user: User) {
        button.hidden = false
        button.tag = user.id

        if user.id == myId {
            button.hidden = true
        }else if user.followingFlag {
            UIView.setAnimationsEnabled(false)
            button.unfollowstyle()
            UIView.setAnimationsEnabled(true)
        }else {
            UIView.setAnimationsEnabled(false)
            button.followstyle()
            UIView.setAnimationsEnabled(true)
        }
    }

    func resetSeparatorStyle() -> Void {
        if self.users.size == 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
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
        cell.userIcon.sd_setImageWithURL(user.icon)
        initFollowButton(cell.followButton as! followButton, user: user)

        return cell
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
