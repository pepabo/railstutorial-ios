import Alamofire
import KeychainAccess

enum Router: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    
    case GetFeed(userId: Int)
    case GetAllUsers()
    case GetFollowers(userId: Int)
    case GetFollowing(userId: Int)
    case PostUser(params: Dictionary<String, String>)
    case PostSession(params: Dictionary<String, String>)
    
    var method: Alamofire.Method {
        switch self {
        case .GetFeed: return .GET
        case .GetAllUsers: return .GET
        case .GetFollowers: return .GET
        case .GetFollowing: return .GET
        case .PostUser: return .POST
        case .PostSession: return .POST
        }
    }
    
    var path: String {
        switch self {
        case .GetFeed(let userId): return "/api/users/\(userId)/feed"
        case .GetAllUsers: return "/api/users"
        case .GetFollowers(let userId): return "/api/users/\(userId)/followers"
        case .GetFollowing(let userId): return "/api/users/\(userId)/following"
        case .PostUser: return "/api/users"
        case .PostSession: return "api/sessions"
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
        case .PostSession(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
