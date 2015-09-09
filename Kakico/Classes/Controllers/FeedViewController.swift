import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll

class FeedViewController: MicropostViewController {
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.showWithMaskType(.Black)
        request()

        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.nextPage != nil) {
                self.request(page: self.microposts.nextPage!)
            }
            tableView.finishInfiniteScroll()
        }
    }

    func request(page: Int = 1) {
        let params = [
            "page": String(page)
        ]
        Alamofire.request(Router.GetFeed(params: params)).responseJSON { (request, response, data, error) -> Void in
            self.setData(data)
        }
    }

    // MARK: - Navigation
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        request()
    }
}
