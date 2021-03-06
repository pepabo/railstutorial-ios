import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import KeychainAccess

class UserListViewController: UITableViewController {
    var users = UserDataManager()
    var myId = 0
    var _selectedId = 0
    var _listType = ""

    // MARK: - View Events
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resetSeparatorStyle()
        SVProgressHUD.showWithMaskType(.Black)
        request(_listType)
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refreshUsers", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
    }

    // MARK: - Actions
    @IBAction func toggleFollow(sender: followButton) {
        if sender.isFollowing() {
            follow(sender.tag)
            sender.unfollowStyle()
        }else {
            showUnfollowingAlert(sender)
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.size
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTableViewCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserTableViewCell
        let user = users[indexPath.row] as User
        cell.userName.text = user.name
        cell.userIcon.sd_setImageWithURL(user.icon)
        initFollowButton(cell.followUserButton, user: user)

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

            let indexPath : NSIndexPath = tableView.indexPathForSelectedRow()!
            let user = users[indexPath.row] as User
            profileView._selectUserId = user.id
        }
    }

    // MARK: - API request methods
    func request(listType: String) {
        navigationItem.title = listType

        let keychain = Keychain(service: "nehan.Kakico")
        if let id = keychain["userId"] {
            myId = id.toInt()!
        }

        if _selectedId == 0 {
            _selectedId = myId
        }

        switch listType {
        case "All Users":
            Alamofire.request(Router.GetAllUsers()).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        case "Followers":
            Alamofire.request(Router.GetFollowers(userId: _selectedId)).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        case "Following":
            Alamofire.request(Router.GetFollowing(userId: _selectedId)).responseJSON { (request, response, data, error) -> Void in
                self.setUserList(data)
            }
        default:
            println("undefined segue.identifier in UserListViewController")
        }
    }

    func follow(followedId: Int) {
        Alamofire.request(Router.PostRelationships(followedId: followedId))
    }

    func unfollow(followedId: Int) {
        Alamofire.request(Router.DeleteRelationships(followedId: followedId))
    }

    // MARK: - Helpers
    func initFollowButton(button: followButton, user: User) {
        button.hidden = false
        button.tag = user.id

        if user.id == myId {
            button.hidden = true
        }else if user.followingFlag {
            UIView.setAnimationsEnabled(false)
            button.unfollowStyle()
            UIView.setAnimationsEnabled(true)
        }else {
            UIView.setAnimationsEnabled(false)
            button.followStyle()
            UIView.setAnimationsEnabled(true)
        }
    }

    func setUserList(data: AnyObject?) {
        println(data)
        var newUsers: [User] = []
        if data != nil {
            let json = JSON(data!)
            println(json)

            for (index: String, subJson: JSON) in json["contents"] {
                var user = User(data: subJson)
                newUsers.append(user)
            }

            users.nextPage = json["next_page"].intValue

            dispatch_async(dispatch_get_main_queue(), {
                self.users.drop()
                self.users.set(newUsers)
                self.tableView!.reloadData()
                self.refreshControl!.endRefreshing()
            })
            resetSeparatorStyle()
            SVProgressHUD.dismiss()
        }
    }

    func refreshUsers () {
        request(_listType)
    }

    func resetSeparatorStyle() -> Void {
        if self.users.size == 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
    }

    func showUnfollowingAlert(button: followButton) {
        let alertController = UIAlertController(title: "Are you sure you want to unfollow?", message: "", preferredStyle: .ActionSheet)
        let unfollowAction = UIAlertAction(title: "Unfollow", style: .Default, handler:{ (action:UIAlertAction!) -> Void in
            self.unfollow(button.tag)
            button.followStyle()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in println("Unfollow canceled")
        }

        alertController.addAction(unfollowAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
