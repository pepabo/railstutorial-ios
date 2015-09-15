//
//  followButton.swift
//  Kakico
//
//  Created by usr0600370 on 2015/09/15.
//  Copyright (c) 2015年 usr0600370. All rights reserved.
//

import UIKit

class followButton: UIButton {
    let twitterBlue = UIColor(red: 0.33333, green: 0.67451, blue: 0.93333, alpha: 1.0)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
    }
    
    func followstyle() {
        self.setTitle("Follow", forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.backgroundColor = twitterBlue
        self.layoutIfNeeded()
    }
    
    func unfollowstyle() {
        self.setTitle("Unfollow", forState: .Normal)
        self.setTitleColor(twitterBlue, forState: .Normal)
        self.backgroundColor = UIColor.whiteColor()
        self.layoutIfNeeded()
    }
    
    func isFollowing() -> Bool {
        return self.titleLabel!.text == "Follow"
    }
}
