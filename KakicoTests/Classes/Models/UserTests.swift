import UIKit
import XCTest
import SwiftyJSON

class UserTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCreateUser() {
        let contents: JSON = [
            "created_at" : "2015-08-24T09:59:06.000Z",
            "email" : "test@test.com",
            "followers_count" : 10,
            "following_count" : 20,
            "following_flag" : true,
            "icon_url" : "https://secure.gravatar.com/avatar",
            "id" : 1,
            "microposts_count" : 51,
            "name" : "hoge",
            "unix_time_created_at" : 1440410346,
            "unix_time_updated_at" : 1441939154,
            "updated_at" : "2015-09-11T02:39:14.000Z",
        ]

        let user = User(data: contents)
        XCTAssertEqual(user.id, contents["id"].int!)
        XCTAssertEqual(user.name, contents["name"].string!)
        XCTAssertEqual(user.email, contents["email"].string!)
        XCTAssertEqual(user.icon, NSURL(string: contents["icon_url"].string!)!)
        XCTAssertEqual(user.micropostsCount, contents["microposts_count"].int!)
        XCTAssertEqual(user.followersCount, contents["followers_count"].int!)
        XCTAssertEqual(user.followingCount, contents["following_count"].int!)
        XCTAssertEqual(user.followingFlag, contents["following_flag"].bool!)
    }
}
