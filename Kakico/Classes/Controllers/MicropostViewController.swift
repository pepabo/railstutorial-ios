import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class MicropostViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    var microposts = MicropostDataManager()

    // MARK: - View Events
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
}
