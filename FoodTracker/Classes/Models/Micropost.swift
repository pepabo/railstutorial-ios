import UIKit

struct Micropost {
    var content: String, picture: NSURL?
}

class MicropostDataManager: NSObject {
    var microposts: [Micropost]
    
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
}
