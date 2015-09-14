import XCTest

class APIClientTests: XCTestCase {
    let apiClient = APIClient()
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }


    func testGetUserSuccess() {
        let expectation = expectationWithDescription("getUserSuccess")

        var sample: User? = nil

        let userId = 1
        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                sample = user
                expectation.fulfill()
            }, onFailure: { (error) -> Void in
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)

        XCTAssertEqual(sample!.id, userId)
    }

    func testGetUserFailure() {
        let expectation = expectationWithDescription("getUserFailure")

        var sample: User? = nil
        let userId = 999999
        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                sample = user
                expectation.fulfill()
            }, onFailure: { (error) -> Void in
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)

        XCTAssertTrue(sample == nil)
    }
}
