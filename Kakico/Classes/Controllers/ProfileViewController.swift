import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ProfileViewController: MicropostViewController {
    // MARK: - Properties
    @IBOutlet weak var header: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.showWithMaskType(.Black)
        request(super._selectUserId, page: 1)

        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            if (self.microposts.nextPage != nil) {
                self.request(super._selectUserId, page: self.microposts.nextPage!)
            }
            
            self.tableView.reloadData()
            
            tableView.finishInfiniteScroll()
        }
    }

    func request(selectUserId: Int, page: Int) {
        let params = [
            "page": String(page)
        ]
        Alamofire.request(Router.GetMicroposts(userId: selectUserId, params: params)).responseJSON { (request, response, data, error) -> Void in
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
                        userId: selectUserId,
                        userIcon: NSURL(string: iconURL),
                        timeAgoInWords:subJson["time_ago_in_words"].string!
                    )
                    self.microposts.set(micropost)
                }

                self.microposts.nextPage = json["next_page"].intValue

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
    //@IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
    //    request(1)
    //}
}
