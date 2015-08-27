import UIKit
import Alamofire

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
    
    func fetchFeed() {
        Alamofire.request(.GET, "https://157.7.190.148/api/users/1/feed")
            .responseJSON { (request, response, JSON, error) in
                println("=============request=============")
                println(request)
                println("=============response============")
                println(response)
                println("=============JSON================")
                println(JSON)
                println("=============error===============")
                println(error)
                println("=================================")
        }
    }
}
