import XCTest

class APIClientTests: XCTestCase {
    let apiClient = APIClient()

    func testGetUserSuccess() {
        let expectation = expectationWithDescription("getUserSuccess")

        let userId = 1
        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                XCTAssertEqual(user.id, userId)
                expectation.fulfill()
            }, onFailure: { (error) -> Void in
                XCTFail()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

    func testGetUserFailure() {
        let expectation = expectationWithDescription("getUserFailure")

        let userId = 999999
        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                XCTFail()
            }, onFailure: { (error) -> Void in
                XCTAssertNotNil(error)
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
