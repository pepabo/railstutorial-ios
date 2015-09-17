import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll

class FeedViewController: MicropostViewController {
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request(size: 30)

        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.lowerId() != 1 && self.microposts.lowerId() != nil) {
                self.request(upperId: self.microposts.lowerId())
            }
            tableView.finishInfiniteScroll()
        }

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refreshFeed", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }

    override func viewDidAppear(animated: Bool) {
        resetFeed()
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        resetSeparatorStyle()
        SVProgressHUD.dismiss()
    }

    func resetFeed() {
        Alamofire.request(Router.GetFeed(params: ["page": "1"])).responseJSON { (request, response, data, error) -> Void in
            self.resetData()
            self.setData(data)
            self.addInfiniteScroll()
        }
    }
    
    func refreshFeed() -> Void {
        Alamofire.request(Router.GetLatestFeed(lastUpdate: self.microposts.lastUpdate())).responseJSON { (request, response, data, error) -> Void in
            self.addData(data, refreshControl: self.refreshControl!)
        }
    }

    func request(upperId: Int? = nil, lowerId: Int? = nil, size: Int? = nil) {
        var params = Dictionary<String, AnyObject>()

        if let upper = upperId {
            params["upper"] = String(upper)
        }
        if let lower = lowerId {
            params["lower"] = String(lower)
        }
        if let s = size {
            params["size"] = String(s)
        }

        Alamofire.request(Router.GetFeed(params: params)).responseJSON { (request, response, data, error) -> Void in
            self.setData(data)
            self.addInfiniteScroll()
        }
    }

    func addInfiniteScroll() {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.lowerId() != 1 && self.microposts.lowerId() != nil) {
                self.request(upperId: self.microposts.lowerId())
            }
            tableView.finishInfiniteScroll()
        }
    }
}
