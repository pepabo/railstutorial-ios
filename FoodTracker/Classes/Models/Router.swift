import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    
    case GetFeed(userId: Int)
    case GetAllUsers()
    case PostUser(params: Dictionary<String, String>)
    
    var method: Alamofire.Method {
        switch self {
        case .GetFeed: return .GET
        case .GetAllUsers: return .GET
        case .PostUser: return .POST
        }
    }
    
    var path: String {
        switch self {
        case .GetFeed(let userId): return "/api/users/\(userId)/feed"
        case .GetAllUsers: return "/api/users"
        case .PostUser: return "/api/users"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .PostUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
