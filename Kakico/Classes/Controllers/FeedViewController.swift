import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class FeedViewController: MicropostViewController {
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Micropost"

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MicropostCell

        let micropost = self.microposts[indexPath.row] as Micropost

        cell.contentLabel.text = micropost.content
        cell.pictureImageView.sd_setImageWithURL(micropost.picture)

        cell.viewWithTag(micropost.user_id)

        return cell
    }
}
