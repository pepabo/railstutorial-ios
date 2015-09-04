import Alamofire
import KeychainAccess

enum Router: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    
    case GetFeed()
    case GetAllUsers()
    case GetUser(userId: Int)
    case GetFollowers(userId: Int)
    case GetFollowing(userId: Int)
    case PostUser(params: Dictionary<String, String>)
    case PostSession(params: Dictionary<String, String>)
    case PostMicropost(params: Dictionary<String, String>)
    case PostMicropostTest()
    
    var method: Alamofire.Method {
        switch self {
        case .GetFeed: return .GET
        case .GetUser: return .GET
        case .GetAllUsers: return .GET
        case .GetFollowers: return .GET
        case .GetFollowing: return .GET
        case .PostUser: return .POST
        case .PostMicropost: return .POST
        case .PostSession: return .POST
        case .PostMicropostTest: return .POST
        }
    }
    
    var path: String {
        switch self {
        case .GetFeed: return "/api/users/feed"
        case .GetUser(let userId): return "/api/users/\(userId)"
        case .GetAllUsers: return "/api/users"
        case .GetFollowers(let userId): return "/api/users/\(userId)/followers"
        case .GetFollowing(let userId): return "/api/users/\(userId)/following"
        case .PostUser: return "/api/users"
        case .PostMicropost: return "/api/microposts/post"
        case .PostSession: return "api/sessions"
        case .PostMicropostTest: return "/api/microposts/post"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        let keychain = Keychain(service: "nehan.Kakico")
        if let auth_token = keychain["auth_token"] {
            mutableURLRequest.setValue(auth_token, forHTTPHeaderField: "Authorization")
        }

        switch self {
        case .PostUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .PostMicropost(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .PostSession(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
