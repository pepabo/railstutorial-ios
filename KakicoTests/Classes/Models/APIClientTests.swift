import XCTest

class APIClientTests: XCTestCase {
    let apiClient = APIClient()
    let apiStub = APIStub()

    func testGetUserSuccess() {
        let expectation = expectationWithDescription("getUserSuccess")

        apiClient.getUser(apiStub.userId,
            onSuccess: { (user) -> Void in
                XCTAssertEqual(user.id, self.apiStub.userId)
                expectation.fulfill()
            }, onFailure: { (error) -> Void in
                XCTFail()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

    func testGetUserFailure() {
        let expectation = expectationWithDescription("getUserFailure")

        apiClient.getUser(apiStub.illegalValue,
            onSuccess: { (user) -> Void in
                XCTFail()
            }, onFailure: { (error) -> Void in
                XCTAssertNotNil(error)
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
