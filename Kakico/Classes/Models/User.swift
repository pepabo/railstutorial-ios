import UIKit
import SwiftyJSON

struct User {
    let id: Int,
        name: String,
        email: String,
        icon: NSURL,
        micropostsCount: Int,
        followersCount: Int,
        followingCount: Int,
        followingFlag: Bool

    init(data: JSON) {
        id = data["id"].int!
        name = data["name"].string!
        email = data["email"].string!
        icon = NSURL(string: data["icon_url"].string!)!
        micropostsCount = data["microposts_count"].int!
        followersCount = data["followers_count"].int!
        followingCount = data["following_count"].int!
        followingFlag = data["following_flag"].bool!
    }
}

class UserDataManager: NSObject {
    var users: [User]
    var nextPage: Int?
    
    override init() {
        self.users = []
    }
    
    var size : Int {
        return self.users.count
    }
    
    subscript(index: Int) -> User {
        return self.users[index]
    }
    
    func set(user: User) {
        self.users.append(user)
    }
}
