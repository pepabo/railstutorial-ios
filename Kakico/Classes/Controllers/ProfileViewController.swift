import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import UIScrollView_InfiniteScroll

class ProfileViewController: MicropostViewController {
    // MARK: - Properties
    @IBOutlet weak var header: UIView!
    var _selectUserId: Int = 0

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request(_selectUserId)
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

    func addInfiniteScroll() {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            if (self.microposts.nextPage != nil) {
                self.request(self._selectUserId, page: self.microposts.nextPage!)
            }
            tableView.finishInfiniteScroll()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ProfileHeaderView" {
            var headerView: ProfileHeaderViewController = segue.destinationViewController as! ProfileHeaderViewController

            headerView._selectUserId = self._selectUserId
        }
    }
}
