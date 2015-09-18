import UIKit

class followButton: UIButton {
    let twitterBlue = UIColor(red: 0.33333, green: 0.67451, blue: 0.93333, alpha: 1.0)

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
    }
    
    func followstyle() {
        setTitle("Follow", forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backgroundColor = twitterBlue
        layoutIfNeeded()
    }
    
    func unfollowstyle() {
        setTitle("Unfollow", forState: .Normal)
        setTitleColor(twitterBlue, forState: .Normal)
        backgroundColor = UIColor.whiteColor()
        layoutIfNeeded()
    }
    
    func isFollowing() -> Bool {
        return titleLabel!.text == "Follow"
    }
}
