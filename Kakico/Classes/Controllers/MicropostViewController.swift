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
        let micropost = self.microposts[indexPath.row] as Micropost

        return micropost.havePicture() ? 216 : 66
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // MARK: -
    func resetData() {
        self.microposts = MicropostDataManager()
    }

    func setData(data: AnyObject?) {
        println(data)
        if data != nil {
            let json = JSON(data!)
            println(json)

            for (index: String, subJson: JSON) in json["contents"] {
                let micropost = Micropost(data: subJson)
                self.microposts.set(micropost)
            }

            self.microposts.nextPage = json["next_page"].intValue

            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            resetSeparatorStyle()
            SVProgressHUD.dismiss()
        }
    }

    func addData(data: AnyObject?, refreshControl: UIRefreshControl? = nil) {
        println(data)
        var newMicroposts: [Micropost] = []
        if data != nil {
            let json = JSON(data!)
            println(json)

            for (index: String, subJson: JSON) in json["contents"] {
                let micropost = Micropost(data: subJson)
                newMicroposts.append(micropost)
            }
            self.microposts.add(newMicroposts)

            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            if let refreshControl = self.refreshControl {
                refreshControl.endRefreshing()
            }
            resetSeparatorStyle()
            SVProgressHUD.dismiss()
        }
    }

    func resetSeparatorStyle() -> Void {
        if self.microposts.size == 0 {
            self.tableView.separatorStyle = .None
        } else {
            self.tableView.separatorStyle = .SingleLine
        }
    }

}
