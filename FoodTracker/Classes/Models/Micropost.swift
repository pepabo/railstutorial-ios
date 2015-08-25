import UIKit

class Micropost {
    // MARK: - Properties
    var name: String
    var photo: UIImage?
    
    // MARK: - Initialization
    init?(name: String, photo: UIImage?) {
        self.name = name
        self.photo = photo

        if name.isEmpty {
            return nil
        }
    }
}
