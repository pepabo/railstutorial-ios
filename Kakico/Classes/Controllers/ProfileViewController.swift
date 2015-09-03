import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ProfileViewController: MicropostViewController {
    // MARK: - Properties
    @IBOutlet weak var header: UIView!

    var _userId = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        request(_userId)

//        let hoge = self.childViewControllers.first as! ProfileHeaderViewController
    }

    func request(userId: Int) {
        SVProgressHUD.showWithMaskType(.Black)
        Alamofire.request(Router.GetMicroposts(userId: userId)).responseJSON { (request, response, data, error) -> Void in
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
                        user_id: subJson["user_id"].int!
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
}
