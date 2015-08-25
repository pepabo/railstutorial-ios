import UIKit

class Micropost {
    // MARK: - Properties
    var content: String
    var picture: UIImage?
    
    // MARK: - Initialization
    init?(content: String, picture: UIImage?) {
        self.content = content
        self.picture = picture

        if content.isEmpty {
            return nil
        }
    }
}
