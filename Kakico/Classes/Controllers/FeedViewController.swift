import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class FeedViewController: UITableViewController {
    // MARK: - Properties
    var microposts = MicropostDataManager()
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func request() {
        Alamofire.request(Router.GetFeed(userId: 1)).responseJSON { (request, response, data, error) -> Void in
            println(data)
            if data != nil {
                let json = JSON(data!)
                println(json)
                
                for (index: String, subJson: JSON) in json["contents"] {
                    var picture = ""
                    if let url = subJson["picture"]["url"].string {
                        picture = url
                    }
                    var micropost: Micropost = Micropost(
                        content: subJson["content"].string!,
                        picture: NSURL(string: picture)
                    )
                    self.microposts.set(micropost)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
            }
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
        
        cell.contentLabel.text = micropost.content
        cell.pictureImageView.sd_setImageWithURL(micropost.picture)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 216
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MicropostViewController, micropost = sourceViewController.micropost {
            let newIndexPath = NSIndexPath(forRow: self.microposts.size, inSection: 0)
            self.microposts.add(micropost)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }
}
