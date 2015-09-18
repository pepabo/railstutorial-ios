import XCTest
import SwiftyJSON

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
            }, onFailure: { (error, messages) -> Void in
                XCTAssertNotNil(error)
                XCTAssertFalse(messages == nil)
                if messages != nil {
                    let message = messages!["notice"].array!.first?.stringValue as String!
                    XCTAssertEqual(message, "User not found, maybe id 999999 is invalid.")
                }
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

    func testDeleteMicropostSuccess() {
        let expectation = expectationWithDescription("getDeleteMicropostSuccess")

        apiClient.deleteMicropost(apiStub.micropostId,
            onSuccess: { () -> Void in
                expectation.fulfill()
            }, onFailure: { (error, messages) -> Void in
                XCTFail()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

    func testDeleteMicropostFailure() {
        let expectation = expectationWithDescription("getDeleteMicropostFailure")

        apiClient.deleteMicropost(apiStub.illegalMicropostId,
            onSuccess: { () -> Void in
                XCTFail()
            }, onFailure: { (error, messages) -> Void in
                XCTAssertNotNil(error)
                XCTAssertFalse(messages == nil)
                if messages != nil {
                    let message = messages!["notice"].array!.first?.stringValue as String!
                    XCTAssertEqual(message, "Micropost not found, maybe id 999999 is invalid.")
                }
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
