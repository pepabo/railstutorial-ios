import UIKit
import Alamofire
import SwiftyJSON

class FeedViewController: UITableViewController {
    // MARK: - Properties
//    var microposts = [Micropost]()
    
    var microposts = MicropostDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadSampleMicroposts()
        
        //tmp
//        let user = User(name: "cat", icon: "")!
//        user.fetchFeed()
    }
    
    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        self.tableView.reloadData()
        self.request()
    }
    
    func request() {
        Alamofire.request(Router.GetFeed()).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            
            for (index: String, subJson: JSON) in json["contents"] {
                var micropost: Micropost = Micropost(
                    content: subJson["content"].string!,
                    picture: nil
//                    picture: NSURL(string: subJson["picture"].string!)!
                )
                self.microposts.set(micropost)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView!.reloadData()
            })
        }
    }
    
//    func loadSampleMicroposts() {
//        let photo1 = UIImage(named: "micropost1.jpg")!
//        let micropost1 = Micropost(content: "ねこはかわいい", picture: photo1)!
//        
//        let photo2 = UIImage(named: "micropost2.jpg")!
//        let micropost2 = Micropost(content: "かわいいは正義", picture: photo2)!
//        
//        let photo3 = UIImage(named: "micropost3.jpg")!
//        let micropost3 = Micropost(content: "つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義つまりねこは正義", picture: photo3)!
//        
//        let micropost4 = Micropost(content: "かわいいは正義", picture: nil)!
//        
//        microposts += [micropost1, micropost2, micropost3, micropost4]
//    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return microposts.count
        return self.microposts.size
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Micropost"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MicropostCell
        
//        let micropost = microposts[indexPath.row]
        let micropost: Micropost = self.microposts[indexPath.row] as Micropost
        
        cell.contentLabel.text = micropost.content
//        cell.pictureImageView.image = UIImage(data: NSData(contentsOfURL: micropost.picture!)!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 216
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation
//    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController as? MicropostViewController, micropost = sourceViewController.micropost {
//            let newIndexPath = NSIndexPath(forRow: microposts.count, inSection: 0)
//            microposts.append(micropost)
//            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
//        }
//    }
}
