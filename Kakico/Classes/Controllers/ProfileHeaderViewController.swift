import UIKit
import Alamofire
import SwiftyJSON

class ProfileHeaderViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var postCount: UIButton!
    @IBOutlet weak var followingCount: UIButton!
    @IBOutlet weak var followerCount: UIButton!
    @IBOutlet weak var followButton: UIButton!

    var _selectUserId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request(_selectUserId)
    }

    @IBAction func followOrUnfollow(sender: UIButton) {
        if sender.titleLabel?.text == "Follow" {
            sender.setTitle("Unfollow", forState: .Normal)
            sender.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }else {
            sender.setTitle("Follow", forState: .Normal)
            let hoge = UIColor(red: 19.0, green: 121.0, blue: 255.0, alpha: 1.0)
            sender.setTitleColor(UIColor.DefaultColor(), forState: .Normal)
        }
    }

    func request(selectUserId: Int) {
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
            }
        }
    }
}
