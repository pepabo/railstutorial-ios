import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    
    case GetFeed(userId: Int)
    case GetAllUsers()
    case GetFollowers(userId: Int)
    case GetFollowing(userId: Int)
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .GetFeed(let userId): return (.GET, "/api/users/\(userId)/feed", nil)
            case .GetAllUsers(): return (.GET, "/api/users/", nil)
            case .GetFollowers(let userId): return (.GET, "/api/users/\(userId)/followers", nil)
            case .GetFollowing(let userId): return (.GET, "/api/users/\(userId)/following", nil)
            }
            }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(path))
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}