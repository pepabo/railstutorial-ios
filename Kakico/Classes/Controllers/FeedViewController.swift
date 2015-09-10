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
