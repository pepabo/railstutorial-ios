import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ProfileViewController: MicropostViewController {
    // MARK: - Properties
    @IBOutlet weak var header: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        request(super._selectUserId)
    }

    func request(selectUserId: Int) {
        SVProgressHUD.showWithMaskType(.Black)
        Alamofire.request(Router.GetMicroposts(userId: selectUserId)).responseJSON { (request, response, data, error) -> Void in
            println(data)
            if data != nil {
                let json = JSON(data!)
                println(json)

                for (index: String, subJson: JSON) in json["contents"] {
                    var picture = ""
                    var userName = "No name"
                    var iconURL = ""
                    if let url = subJson["picture"]["url"].string {
                        picture = url
                    }
                    if let name = subJson["user"]["name"].string {
                        userName = name
                    }
                    if let url = subJson["user"]["icon_url"].string {
                        iconURL = url
                    }
                    var micropost: Micropost = Micropost(
                        userName: userName,
                        content: subJson["content"].string!,
                        picture: NSURL(string: picture),
                        user_id: selectUserId,
                        userIcon: NSURL(string: iconURL),
                        timeAgoInWords:subJson["time_ago_in_words"].string!
                    )
                    self.microposts.set(micropost)
                }

                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.showErrorWithStatus("", maskType: .Black)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ProfileHeaderView" {
            var headerView: ProfileHeaderViewController = segue.destinationViewController as! ProfileHeaderViewController

            headerView._selectUserId = self._selectUserId
        }
    }

    // MARK: - Navigation
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        request(1)
    }
}
