import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll

class MicropostViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    var microposts = MicropostDataManager()

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.showWithMaskType(.Black)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
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

    // MARK: -
    func setData(data: AnyObject?) {
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
                let pictureURL = picture.isEmpty ? nil : NSURL(string: picture)
                var micropost: Micropost = Micropost(
                    userName: userName,
                    content: subJson["content"].string!,
                    picture: pictureURL,
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
