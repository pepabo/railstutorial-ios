import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll

class ProfileViewController: MicropostViewController {
    @IBOutlet weak var header: UIView!
    var _selectUserId: Int = 0

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request(_selectUserId)

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refreshProfile", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ProfileHeaderView" {
            var headerView: ProfileHeaderViewController = segue.destinationViewController as! ProfileHeaderViewController

            headerView._selectUserId = self._selectUserId
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return microposts.hasNextPage() ? microposts.size : microposts.size + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLastMicropost(indexPath) {
            removeInfiniteScroll()
            let cellIdentifier = "Infomation"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isLastMicropost(indexPath) {
            return UITableViewAutomaticDimension
        }
        return super.tableView(tableView, estimatedHeightForRowAtIndexPath: indexPath)
    }

    // MARK: - API request methods
    func refreshProfile() -> Void {
        var profileHeaderView = self.childViewControllers.first as! ProfileHeaderViewController
        profileHeaderView.request(_selectUserId)

        Alamofire.request(Router.GetLatestMicroposts(userId: self._selectUserId, lastUpdate: self.microposts.lastUpdate())).responseJSON { (request, response, data, error) -> Void in
            self.addData(data, refreshControl: self.refreshControl!)
        }
    }

    func request(selectUserId: Int, page: Int = 1) {
        let params = [
            "page": String(page)
        ]
        Alamofire.request(Router.GetMicroposts(userId: selectUserId, params: params)).responseJSON { (request, response, data, error) -> Void in
                self.setData(data)
                self.addInfiniteScroll()
        }
    }

    // MARK: - Helpers
    func addInfiniteScroll() {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.nextPage != nil) {
                self.request(self._selectUserId, page: self.microposts.nextPage!)
            }
            tableView.finishInfiniteScroll()
        }
    }

    func removeInfiniteScroll() {
        tableView.removeInfiniteScroll()
    }

    func isLastMicropost(indexPath:NSIndexPath) -> Bool {
        return indexPath.row >= microposts.size
    }
}
