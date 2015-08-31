import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    
    case GetFeed()
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .GetFeed: return (.GET, "/api/users/1/feed", nil)
            }
            }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(path))
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}