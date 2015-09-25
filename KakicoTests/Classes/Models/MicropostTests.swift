import UIKit
import XCTest
import SwiftyJSON

class MicropostTests: XCTestCase {
    var manager = MicropostDataManager()

    override func setUp() {
        super.setUp()
        for i in 1...10 {
            let post = createRandomMicropost(randomInt: i)
            manager.set(post)
        }
    }

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
        XCTAssertEqual(post.userName, contents["user"]["name"].stringValue)
        XCTAssertEqual(post.content, contents["content"].stringValue)
        XCTAssertEqual(post.picture!, NSURL(string: contents["picture"]["url"].stringValue)!)
        XCTAssertEqual(post.userId, contents["user_id"].intValue)
        XCTAssertEqual(post.userIcon, NSURL(string: contents["user"]["icon_url"].stringValue)!)
        XCTAssertEqual(post.timeAgoInWords, contents["time_ago_in_words"].stringValue)
        XCTAssertEqual(post.unixTimeCreatedAt, contents["unix_time_created_at"].intValue)
    }

    func testGetUpperId() {
        XCTAssertEqual(10, manager.upperId()!)
    }

    func testGetLowerId() {
        XCTAssertEqual(1, manager.lowerId()!)
    }

    func testTimeAgoInWords() {
        let date = NSDate()
        let micropost = createRandomMicropost(randomInt: Int(date.timeIntervalSince1970))
        XCTAssertEqual("Just now", micropost.getTimeAgoInWords())
    }

    func testHasNextPage() {
        manager.nextPage = nil
        XCTAssertFalse(manager.hasNextPage())
        manager.nextPage = 0
        XCTAssertFalse(manager.hasNextPage())
        manager.nextPage = 1
        XCTAssert(manager.hasNextPage())
    }

    func createRandomMicropost(randomInt: Int = Int(arc4random())) -> Micropost {
        let contents: JSON = [
            "id": randomInt,
            "content": "Random content \(randomInt)",
            "user_id": randomInt,
            "time_ago_in_words": "\(randomInt) minutes",
            "created_at": "2015-09-16T00:42:44.000Z",
            "updated_at": "2015-09-16T00:42:44.000Z",
            "picture": [ "url": "hoge.png" ],
            "user": [
                "name": "neco",
                "icon_url": "https://secure.gravatar.com/avatar/"
            ],
            "unix_time_created_at": randomInt,
            "unix_time_updated_at": randomInt
        ]
        return Micropost(data: contents)
    }
}
