import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ProfileViewController: MicropostViewController {
    // MARK: - Properties
    @IBOutlet weak var header: UIView!

    override func viewDidLoad() {
//        var headerView = self.childViewControllers.first as! ProfileHeaderViewController
//        headerView._selectUserId = super._selectUserId

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
                    if let url = subJson["picture"]["url"].string {
                        picture = url
                    }
                    var micropost: Micropost = Micropost(
                        content: subJson["content"].string!,
                        picture: NSURL(string: picture),
                        user_id: selectUserId
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
}
