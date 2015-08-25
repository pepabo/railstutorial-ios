import UIKit
import XCTest

class UserTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testUserInitialization() {
        let user = User(name: "hoge", icon: "")
        XCTAssertNotNil(user)
    }
}
