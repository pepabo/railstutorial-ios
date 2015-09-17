import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll

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
}
