import UIKit
import XCTest
import SwiftyJSON

class MicropostTests: XCTestCase {
    func testCreateMicropost() {
        let contents: JSON = [
            "id": 227,
            "content": "リアルねこあつめは最高のコンテンツです",
            "user_id": 1,
            "time_ago_in_words": "10 minutes",
            "created_at": "2015-09-16T00:42:44.000Z",
            "updated_at": "2015-09-16T00:42:44.000Z",
            "picture": [ "url": "hoge.png" ],
            "user": [
                "name": "neco",
                "icon_url": "https://secure.gravatar.com/avatar/"
            ],
            "unix_time_created_at": 1442364164,
            "unix_time_updated_at": 1442364164
        ]

        let post = Micropost(data: contents)
        XCTAssertEqual(post.userName, contents["user"]["name"].string!)
        XCTAssertEqual(post.content, contents["content"].string!)
        XCTAssertEqual(post.picture!, NSURL(string: contents["picture"]["url"].string!)!)
        XCTAssertEqual(post.userId, contents["user_id"].int!)
        XCTAssertEqual(post.userIcon, NSURL(string: contents["user"]["icon_url"].string!)!)
        XCTAssertEqual(post.timeAgoInWords, contents["time_ago_in_words"].string!)
        XCTAssertEqual(post.unixTimeCreatedAt, contents["unix_time_created_at"].intValue)
    }
}
