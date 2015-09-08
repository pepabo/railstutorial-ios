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
            
            if (self.microposts.next_page != nil) {
                self.request(self.microposts.next_page!)
            }
            
            self.tableView.reloadData()
            
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
                
                self.microposts.next_page = json["next_page"].intValue
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.showErrorWithStatus("", maskType: .Black)
            }
            
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.microposts.size
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

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 216
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // MARK: - Navigation
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        request(1)
    }
}
