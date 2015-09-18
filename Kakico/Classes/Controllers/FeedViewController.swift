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
        addInfiniteScroll()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refreshFeed", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        resetFeed()
    }

    func resetFeed() {
        let params = [
            "size": self.microposts.size
        ]

        Alamofire.request(Router.GetFeed(params: params)).responseJSON { (request, response, data, error) -> Void in
            self.resetData()
            self.setData(data)
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
            params["upper"] = upper
        }
        if let lower = lowerId {
            params["lower"] = lower
        }
        if let s = size {
            params["size"] = s
        }

        Alamofire.request(Router.GetFeed(params: params)).responseJSON { (request, response, data, error) -> Void in
            self.setData(data)
        }
    }

    func addInfiniteScroll() {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if self.microposts.lowerId() != nil {
                self.request(upperId: self.microposts.lowerId())
            }
            tableView.finishInfiniteScroll()
        }
    }
}
