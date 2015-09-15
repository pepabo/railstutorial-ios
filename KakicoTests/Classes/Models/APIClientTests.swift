import XCTest
import OHHTTPStubs

class APIClientTests: XCTestCase {
    let apiClient = APIClient()

    override func setUp() {
        super.setUp()

    }

    func testGetUserSuccess() {
        let userId = 1

        OHHTTPStubs.stubRequestsPassingTest(
            { (request: NSURLRequest) -> Bool in
                if request.URL?.absoluteString == "https://157.7.190.148/api/users/" + String(userId) {
                    return true
                }
                return false
            }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(fileAtPath:OHPathForFile("user.json", self.dynamicType)!,
                    statusCode:200, headers:["Content-Type":"application/json"])
        })

        let expectation = expectationWithDescription("getUserSuccess")

        apiClient.getUser(userId,
            onSuccess: { (user) -> Void in
                XCTAssertEqual(user.id, userId)
                expectation.fulfill()
            }, onFailure: { (error) -> Void in
                XCTFail()
        })

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
//
//    func testGetUserFailure() {
//        let expectation = expectationWithDescription("getUserFailure")
//
//        let userId = 999999
//        apiClient.getUser(userId,
//            onSuccess: { (user) -> Void in
//                XCTFail()
//            }, onFailure: { (error) -> Void in
//                XCTAssertNotNil(error)
//                expectation.fulfill()
//        })
//
//        waitForExpectationsWithTimeout(5.0, handler: nil)
//    }
}
