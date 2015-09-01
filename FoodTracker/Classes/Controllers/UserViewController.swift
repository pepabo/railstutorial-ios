import UIKit

class UserViewController: UITableViewController {
    // MARK: - Properties
    var users = UserDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
