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
                case "/api/users/\(self.userId)": return self.stubJson("user", status: 200)
                case "/api/users/\(self.illegalValue)": return self.stubJson("user_404", status: 404)
                default: return self.stubJson("500", status: 500)
            }
        })
    }

    private func checkHost(request: NSURLRequest) -> Bool {
        if request.URL != nil {
            let scheme = request.URL!.scheme as String!
            let host = request.URL!.host as String!
            if Router.baseURLString.hasPrefix("\(scheme)://\(host)") {
                return true
            }
        }
        return false
    }

    private func stubJson(var fileName: String, status: Int32) -> OHHTTPStubsResponse {
        if !fileName.hasSuffix(".json") {
            fileName = fileName + ".json"
        }
        return OHHTTPStubsResponse(fileAtPath:OHPathForFile(fileName, self.dynamicType)!,
            statusCode:status, headers:["Content-Type":"application/json"])
    }
}
