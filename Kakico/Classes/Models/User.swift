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
        id = data["id"].intValue
        name = data["name"].stringValue
        email = data["email"].stringValue
        icon = NSURL(string: data["icon_url"].stringValue)!
        micropostsCount = data["microposts_count"].intValue
        followersCount = data["followers_count"].intValue
        followingCount = data["following_count"].intValue
        followingFlag = data["following_flag"].boolValue
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

    func drop() {
        self.users.removeAll()
    }
}
