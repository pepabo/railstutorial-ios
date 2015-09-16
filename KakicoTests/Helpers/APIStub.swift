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
                case "/api/users/\(self.userId)": return self.stubJson("user")
                default: return self.stubJson("500")
                }
        })
    }

    private func checkHost(request: NSURLRequest) -> Bool {
        if request.URL != nil && request.URL!.host != nil && Router.baseURLString.hasSuffix(request.URL!.host!) {
            return true
        }
        return false
    }

    private func stubJson(fileName: String) -> OHHTTPStubsResponse {
        var tmp = fileName
        if !fileName.hasSuffix(".json") {
            tmp = fileName + ".json"
        }
        return OHHTTPStubsResponse(fileAtPath:OHPathForFile(tmp, self.dynamicType)!,
            statusCode:200, headers:["Content-Type":"application/json"])
    }
}