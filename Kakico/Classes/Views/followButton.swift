import UIKit

class followButton: UIButton {
    let twitterBlue = UIColor(red: 0.33333, green: 0.67451, blue: 0.93333, alpha: 1.0)

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
    }
    
    func followStyle() {
        setTitle("Follow", forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backgroundColor = twitterBlue
        layoutIfNeeded()
    }
    
    func unfollowStyle() {
        setTitle("Unfollow", forState: .Normal)
        setTitleColor(twitterBlue, forState: .Normal)
        backgroundColor = UIColor.whiteColor()
        layoutIfNeeded()
    }

    func configStyle() {
        setTitle("Settings", forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backgroundColor = UIColor.lightGrayColor()
        layoutIfNeeded()
    }
    
    func isFollowing() -> Bool {
        return titleLabel!.text == "Follow"
    }

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var rect: CGRect = bounds
        rect.origin.x -= 10
        rect.origin.y -= 10
        rect.size.width += 20
        rect.size.height += 20

        return CGRectContainsPoint(rect, point)
    }
}
