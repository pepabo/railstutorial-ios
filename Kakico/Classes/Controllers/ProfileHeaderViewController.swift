import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class ProfileHeaderViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var postCount: UIButton!
    @IBOutlet weak var followingCount: UIButton!
    @IBOutlet weak var followerCount: UIButton!
    @IBOutlet weak var followUserButton: followButton!

    var _selectUserId = 0
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request(_selectUserId)
    }

    @IBAction func toggleFollow(sender: followButton) {
        if sender.titleLabel?.text == "Follow" {
            follow(sender.tag)
            sender.unfollowstyle()
        }else {
            showUnfollowingAlert(sender)
        }
    }

    func request(selectUserId: Int) {
        let keychain = Keychain(service: "nehan.Kakico")
        if let id = keychain["userId"] {
            userId = id.toInt()!
        }

        Alamofire.request(Router.GetUser(userId: selectUserId)).responseJSON { (request, response, data, error) -> Void in
            println(data)
            if data != nil {
                let json = JSON(data!)
                println(json)

                let contents = json["contents"]
                self.nameLabel.text = contents["name"].string!
                self.userIcon.sd_setImageWithURL(NSURL(string: contents["icon_url"].string!))
                self.postCount.setTitle(contents["microposts_count"].description, forState: .Normal)
                self.followingCount.setTitle(contents["following_count"].description, forState: .Normal)
                self.followerCount.setTitle(contents["followers_count"].description, forState: .Normal)

                self.initFollowButton(contents["following_flag"].bool!)
            }
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

    func initFollowButton(following_status: Bool) {
        followUserButton.hidden = false
        followUserButton.tag = _selectUserId

        if _selectUserId == userId {
            followUserButton.hidden = true
        }else if following_status {
            UIView.setAnimationsEnabled(false)
            followUserButton.unfollowstyle()
            UIView.setAnimationsEnabled(true)
        }else {
            UIView.setAnimationsEnabled(false)
            followUserButton.followstyle()
            UIView.setAnimationsEnabled(true)
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let userView = segue.destinationViewController as? UserViewController {
            let type = segue.identifier!
            switch type {
            case "Followers":
                userView._listType = "Followers"
            case "Following":
                userView._listType = "Following"
            default:
                println("undefined segue.identifier in ConfigViewController")
            }
            userView._selectedId = _selectUserId
        }
    }
}
