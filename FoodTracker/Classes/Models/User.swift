import UIKit

class User {
    // MARK: - Properties
    var name: String
    var icon: NSURL
    
    // MARK: - Initialization
    init?(name: String, icon: String) {
        let dummyIcon = "https://pbs.twimg.com/profile_images/591295584516079616/EfyAXyyq_400x400.jpg"
        self.name = name
        self.icon = NSURL(string: dummyIcon)!
    }
}
