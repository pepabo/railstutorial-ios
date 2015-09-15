import XCTest
import OHHTTPStubs

class APIClientTests: XCTestCase {
    let apiClient = APIClient()

    func testGetUserSuccess() {
        let userId = 1
        let response = [
            "contents": [
                "created_at" : "2015-08-24T09:59:06.000Z",
                "email": "test@test.com",
                "followers_count": 5,
                "following_count": 10,
                "icon_url": "https://secure.gravatar.com/avatar/",
                "id": 1,
                "microposts_count": 50,
                "name": "test",
                "following_flag": false,
                "unix_time_created_at": 1440410346,
                "unix_time_updated_at": 1441939154,
                "updated_at": "2015-09-11T02:39:14.000Z"
            ],
            "messages": [
                "notice": []
            ],
            "status": 200
        ]

        OHHTTPStubs.stubRequestsPassingTest(
            { (request: NSURLRequest) -> Bool in
                if request.URL?.absoluteString == "https://157.7.190.148/api/users/" + String(userId) {
                    return true
                }
                return false
            }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(JSONObject: response, statusCode:200, headers:nil)
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
