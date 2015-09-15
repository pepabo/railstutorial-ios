import XCTest

class APIClientTests: XCTestCase {
    let apiClient = APIClient()

    func testGetUserSuccess() {
        let expectation = expectationWithDescription("getUserSuccess")

        var sample: User? = nil

        let userId = 1
        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                sample = user
                XCTAssertEqual(sample!.id, userId)
                expectation.fulfill()
            }, onFailure: { (error) -> Void in
                XCTFail()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

    func testGetUserFailure() {
        let expectation = expectationWithDescription("getUserFailure")

        var sample: User? = nil
        let userId = 999999
        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                XCTFail()
            }, onFailure: { (error) -> Void in
                XCTAssertTrue(sample == nil)
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
