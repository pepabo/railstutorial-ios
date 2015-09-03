import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCount: UIButton!
    @IBOutlet weak var followingCount: UIButton!
    @IBOutlet weak var followerCount: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

    func request() {
        Alamofire.request(Router.GetUser(userId: 1)).responseJSON { (request, response, data, error) -> Void in
            println(data)
            if data != nil {
                let json = JSON(data!)
                println(json)

                let contents = json["contents"]
                self.nameLabel.text = contents["name"].string!
                self.userIcon.sd_setImageWithURL(NSURL(string: contents["icon_url"].string!))
                self.postCount.setTitle(contents["microposts_count"].description, forState: UIControlState.Normal)
                self.followingCount.setTitle(contents["following_count"].description, forState: UIControlState.Normal)
                self.followerCount.setTitle(contents["followers_count"].description, forState: UIControlState.Normal)
            }
        }
    }
}
