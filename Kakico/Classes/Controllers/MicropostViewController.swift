import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll
import KeychainAccess

class MicropostViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
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

    // MARK: - Actions
    @IBAction func longPushed(sender: UILongPressGestureRecognizer) {
        let tappedPoint = sender.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(tappedPoint)

        let keychain = Keychain(service: "nehan.Kakico")
        let userId = keychain["userId"]

        if self.microposts[indexPath!.row].userId == userId?.toInt() {
            self.deleteMicropost(indexPath!)
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
        cell.timeAgoInWordsLabel.text = micropost.getTimeAgoInWords()

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

    // MARK: - API request methods
    func deleteMicropost(indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this micropost?", message: "", preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler:{ (action:UIAlertAction!) -> Void in
            let micropostId = self.microposts[indexPath.row].id
            let apiClient = APIClient()
            apiClient.deleteMicropost(micropostId, onSuccess: { () -> Void in
                println("Deleted micropost")
                }, onFailure: { (error, messages) -> Void in
                    println("We couldn't delete it, something was wrong")
            })
            self.microposts.deleteMicropost(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in println("Delete micropost canceled")
        }

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Helpers
    func resetData() {
        self.microposts.drop()
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
            SVProgressHUD.dismiss()
        }
    }
}
