import UIKit

class RoundRectImageView: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}
