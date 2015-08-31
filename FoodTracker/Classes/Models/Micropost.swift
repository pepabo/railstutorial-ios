import UIKit

//class Micropost {
//    // MARK: - Properties
//    var content: String
//    var picture: UIImage?
//    
//    // MARK: - Initialization
//    init?(content: String, picture: UIImage?) {
//        self.content = content
//        self.picture = picture
//
//        if content.isEmpty {
//            return nil
//        }
//    }
//}

struct Micropost {
    var content: String, picture: NSURL?
}

class MicropostDataManager: NSObject {
    var microposts: [Micropost]
    
    class var sharedInstance : MicropostDataManager {
        struct Static {
            static let instance : MicropostDataManager = MicropostDataManager()
        }
        return Static.instance
    }
    
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
