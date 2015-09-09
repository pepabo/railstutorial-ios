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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
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

        cell.userNameLabel.text = micropost.userName
        cell.contentLabel.text = micropost.content
        cell.viewWithTag(micropost.userId)
        cell.userIconImageView.sd_setImageWithURL(micropost.userIcon)
        cell.timeAgoInWordsLabel.text = micropost.timeAgoInWords

        if micropost.havePicture() {
            cell.pictureImageView.hidden = false
            cell.pictureImageViewHeightConstraint.constant = 150
            cell.pictureImageView.sd_setImageWithURL(micropost.picture)
        } else {
            cell.pictureImageView.hidden = true
            cell.pictureImageViewHeightConstraint.constant = 0
        }


        return cell
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellIdentifier = "Micropost"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MicropostCell
        let micropost = self.microposts[indexPath.row] as Micropost

        return micropost.havePicture() ? 216 : 66
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // MARK: - Navigation
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        request(1)
    }
}
