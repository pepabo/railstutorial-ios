import UIKit
import XCTest

class UserTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func createUser() {
        let contents = [
            "created_at" : "2015-08-24T09:59:06.000Z",
            "email" : "test@test.com",
            "followers_count" : 10,
            "following_count" : 20,
            "following_flag" : 1,
            "icon_url" : "https://secure.gravatar.com/avatar",
            "id" : 1,
            "microposts_count" : 51,
            "name" : "hoge",
            "unix_time_created_at" : 1440410346,
            "unix_time_updated_at" : 1441939154,
            "updated_at" : "2015-09-11T02:39:14.000Z",
        ]

        let icon = NSURL(string: contents["icon_url"] as! String)!
        let user = User(
            id: contents["id"] as! Int,
            name: contents["name"] as! String,
            icon: icon,
            followingFlag: contents["following_flag"] as! Bool
        )
        XCTAssertEqual(user.id, contents["id"] as! Int)
    }
}
