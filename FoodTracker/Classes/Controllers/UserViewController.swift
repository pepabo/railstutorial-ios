import UIKit

class UserViewController: UITableViewController {
    // MARK: - Properties
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleUsers()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.userName.text = user.name
        cell.userIcon.imageView?.image = UIImage(data: NSData(contentsOfURL: user.icon)!)
        
        return cell
    }
    
    func loadSampleUsers() {
        let user1 = User(name: "cat", icon: "")!
        let user2 = User(name: "neko", icon: "")!
        let user3 = User(name: "nyah", icon: "")!
        
        users += [user1, user2, user3]
    }
}
