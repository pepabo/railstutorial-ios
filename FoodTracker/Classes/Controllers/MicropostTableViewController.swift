//
//  MicropostTableViewController.swift
//  FoodTracker
//
//  Created by usr0600341 on 2015/08/19.
//  Copyright (c) 2015年 usr0600370. All rights reserved.
//

import UIKit

class MicropostTableViewController: UITableViewController {
    // MARK: Properties
    var microposts = [Micropost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Load the sample data.
        loadSampleMicroposts()
    }
    
    func loadSampleMicroposts() {
        let photo1 = UIImage(named: "micropost1.jpg")!
        let micropost1 = Micropost(name: "ねこはかわいい", photo: photo1)!
        
        let photo2 = UIImage(named: "micropost2.jpg")!
        let micropost2 = Micropost(name: "かわいいは正義", photo: photo2)!
        
        let photo3 = UIImage(named: "micropost3.jpg")!
        let micropost3 = Micropost(name: "つまりねこは正義", photo: photo3)!
        
        microposts += [micropost1, micropost2, micropost3]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return microposts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MicropostTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MicropostTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let micropost = microposts[indexPath.row]
        
        cell.nameLabel.text = micropost.name
        cell.photoImageView.image = micropost.photo
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToMicropostList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MicropostViewController, micropost = sourceViewController.micropost {
            // Add a new meal.
            let newIndexPath = NSIndexPath(forRow: microposts.count, inSection: 0)
            microposts.append(micropost)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }
}
