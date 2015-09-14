import XCTest

class APIClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }


    func testGetUser() {
        let expectation = expectationWithDescription("getUser")

        var sample: User? = nil
        let apiClient = APIClient()
        let userId = 1
        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                sample = user
                expectation.fulfill()
            }, onFailure: { (error) -> Void in
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)

        XCTAssertEqual(sample!.id, userId)
    }
}
