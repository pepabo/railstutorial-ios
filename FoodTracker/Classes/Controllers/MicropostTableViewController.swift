import UIKit

class MicropostTableViewController: UITableViewController {
    // MARK: - Properties
    var microposts = [Micropost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMicroposts()
    }
    
    func loadSampleMicroposts() {
        let photo1 = UIImage(named: "micropost1.jpg")!
        let micropost1 = Micropost(content: "ねこはかわいい", picture: photo1)!
        
        let photo2 = UIImage(named: "micropost2.jpg")!
        let micropost2 = Micropost(content: "かわいいは正義", picture: photo2)!
        
        let photo3 = UIImage(named: "micropost3.jpg")!
        let micropost3 = Micropost(content: "つまりねこは正義", picture: photo3)!
        
        microposts += [micropost1, micropost2, micropost3]
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return microposts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MicropostTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MicropostTableViewCell
        
        let micropost = microposts[indexPath.row]
        
        cell.contentLabel.text = micropost.content
        cell.pictureImageView.image = micropost.picture
        
        return cell
    }
    
    // MARK: - Navigation
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MicropostViewController, micropost = sourceViewController.micropost {
            let newIndexPath = NSIndexPath(forRow: microposts.count, inSection: 0)
            microposts.append(micropost)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }
}
