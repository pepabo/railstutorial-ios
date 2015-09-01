import UIKit

struct User {
    var name: String, icon: NSURL
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
