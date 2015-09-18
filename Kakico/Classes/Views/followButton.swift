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
        setTitle("Edit Profile", forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backgroundColor = UIColor.lightGrayColor()
        layoutIfNeeded()
    }
    
    func isFollowing() -> Bool {
        return titleLabel!.text == "Follow"
    }
}
