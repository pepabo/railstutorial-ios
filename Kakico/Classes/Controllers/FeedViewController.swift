import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll

class FeedViewController: MicropostViewController {
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.showWithMaskType(.Black)
        request(1)

        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.nextPage != nil) {
                self.request(self.microposts.nextPage!)
            }
            tableView.finishInfiniteScroll()
        }
    }

    func request(page: Int) {
        let params = [
            "page": String(page)
        ]
        Alamofire.request(Router.GetFeed(params: params)).responseJSON { (request, response, data, error) -> Void in
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
                    let pictureUrl = picture.isEmpty ? nil : NSURL(string: picture)
                    var micropost: Micropost = Micropost(
                        userName: userName,
                        content: subJson["content"].string!,
                        picture: pictureUrl,
                        userId: subJson["user_id"].int!,
                        userIcon: NSURL(string: iconURL),
                        timeAgoInWords:subJson["time_ago_in_words"].string!
                    )                  
                    self.microposts.set(micropost)
                }
                
                self.microposts.nextPage = json["next_page"].intValue
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }

    // MARK: - Navigation
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        request(1)
    }
}
