import UIKit
import Alamofire
import SwiftyJSON

class UserViewController: UITableViewController {
    // MARK: - Properties
    var users = UserDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.request()
    }
    
    func request() {
        Alamofire.request(Router.GetAllUsers()).responseJSON { (request, response, data, error) -> Void in
            println(data)
            if data != nil {
                let json = JSON(data!)
                println(json)
                
//                for (index: String, subJson: JSON) in json["contents"] {
//                    var picture = ""
//                    if let url = subJson["picture"]["url"].string {
//                        picture = url
//                    }
//                    var micropost: Micropost = Micropost(
//                        content: subJson["content"].string!,
//                        picture: NSURL(string: picture)
//                    )
//                    self.microposts.set(micropost)
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.tableView!.reloadData()
//                })
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.size
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.userName.text = user.name
        cell.userIcon.imageView?.image = UIImage(data: NSData(contentsOfURL: user.icon)!)
        
        return cell
    }
}
