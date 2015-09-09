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
    @IBOutlet weak var followButton: UIButton!

    var _selectUserId = 0
    var currentUserId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request(_selectUserId)
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

    func request(selectUserId: Int) {
        let keychain = Keychain(service: "nehan.Kakico")
        if let id = keychain["userId"] {
            currentUserId = id.toInt()!
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

    func follow(followedId: Int) {
        Alamofire.request(Router.PostRelationships(followedId: followedId))
    }

    func unfollow(followedId: Int) {
        Alamofire.request(Router.DeleteRelationships(followedId: followedId))
    }

    func initFollowButton(following_status: Bool) {
        followButton.hidden = false
        followButton.tag = _selectUserId

        if _selectUserId == currentUserId {
            followButton.hidden = true
        }else if following_status {
            followButtonStyle(followButton)
        }else {
            unfollowButtonStyle(followButton)
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
}
