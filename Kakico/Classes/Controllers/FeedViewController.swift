import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll
import KeychainAccess

class FeedViewController: MicropostViewController {
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request()

        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.nextPage != nil) {
                self.request(page: self.microposts.nextPage!)
            }
            tableView.finishInfiniteScroll()
        }
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refreshFeed", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    func refreshFeed() -> Void {
        Alamofire.request(Router.GetLatestFeed(lastUpdate: self.microposts.lastUpdate())).responseJSON { (request, response, data, error) -> Void in
            self.addData(data, refreshControl: self.refreshControl!)
        }
    }
    
    func request(page: Int = 1) {
        let params = [
            "page": String(page)
        ]
        Alamofire.request(Router.GetFeed(params: params)).responseJSON { (request, response, data, error) -> Void in
            self.setData(data)
            self.addInfiniteScroll()
        }
    }

    func addInfiniteScroll() {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.nextPage != nil) {
                self.request(page: self.microposts.nextPage!)
            }
            tableView.finishInfiniteScroll()
        }
    }
    @IBAction func longPushed(sender: UILongPressGestureRecognizer) {
        let tappedPoint = sender.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(tappedPoint)

        let keychain = Keychain(service: "nehan.Kakico")
        let userId = keychain["userId"]

        if self.microposts[indexPath!.row].userId == userId?.toInt() {
            self.deleteMicropost(indexPath!)
        }
    }
}
