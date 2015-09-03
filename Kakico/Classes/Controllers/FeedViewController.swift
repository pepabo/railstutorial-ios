import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class FeedViewController: MicropostViewController {
    override func request() {
        SVProgressHUD.showWithMaskType(.Black)
        Alamofire.request(Router.GetFeed()).responseJSON { (request, response, data, error) -> Void in
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
                        picture: NSURL(string: picture)
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
