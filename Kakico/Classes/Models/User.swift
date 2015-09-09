import UIKit

struct User {
    var id: Int, name: String, icon: NSURL, followingFlag: Bool
}

class UserDataManager: NSObject {
    var users: [User]
    
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
