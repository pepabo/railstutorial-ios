import OHHTTPStubs

class APIStub {
    let userId = 1
    let illegalValue = 999999

    init() {
        OHHTTPStubs.stubRequestsPassingTest(
            { (request: NSURLRequest) -> Bool in
                return self.checkHost(request)
            }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                switch request.URL!.path! {
                case "/api/users/\(self.userId)": return OHHTTPStubsResponse(fileAtPath:OHPathForFile("user.json", self.dynamicType)!,
                    statusCode:200, headers:["Content-Type":"application/json"])
                default: return OHHTTPStubsResponse(fileAtPath:OHPathForFile("500.json", self.dynamicType)!,
                    statusCode:500, headers:["Content-Type":"application/json"])
                }
        })
    }

    private func checkHost(request: NSURLRequest) -> Bool {
        if request.URL != nil && request.URL!.host != nil && Router.baseURLString.hasSuffix(request.URL!.host!) {
            return true
        }
        return false
    }
}