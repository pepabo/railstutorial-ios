import UIKit

struct Micropost {
    var userName: String,
    content: String,
    picture: NSURL?,
    user_id: Int,
    userIcon: NSURL?,
    timeAgoInWords: String
}

class MicropostDataManager: NSObject {
    var microposts: [Micropost]
    var next_page: Int?
    
    override init() {
        self.microposts = []
    }
    
    var size : Int {
        return self.microposts.count
    }
    
    subscript(index: Int) -> Micropost {
        return self.microposts[index]
    }
    
    func set(micropost: Micropost) {
        self.microposts.append(micropost)
    }
    
    func add(micropost: Micropost) {
        self.microposts.insert(micropost, atIndex: 0)
    }
}
