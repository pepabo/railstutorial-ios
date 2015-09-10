import Alamofire
import KeychainAccess

enum Router: URLRequestConvertible {
    static let baseURLString = "https://157.7.190.148"

    case GetUser(userId: Int)

    case GetFeed(params: Dictionary<String, String>)
    case GetAllUsers(params: Dictionary<String, String>)

    case GetFollowers(userId: Int, params: Dictionary<String, String>)
    case GetFollowing(userId: Int, params: Dictionary<String, String>)
    case GetMicroposts(userId: Int, params: Dictionary<String, String>)

    case PostUser(params: Dictionary<String, String>)
    case PostSession(params: Dictionary<String, String>)
    case PostMicropost()
    
    case PostRelationships(followedId: Int)
    case DeleteRelationships(followedId: Int)

    case PostPasswordResetEmail(params: Dictionary<String, String>)
    case UpdatePassword(params: Dictionary<String, String>)
    
    var method: Alamofire.Method {
        switch self {
        case .GetUser: return .GET
        case .GetFeed: return .GET
        case .GetAllUsers: return .GET
        case .GetFollowers: return .GET
        case .GetFollowing: return .GET
        case .GetMicroposts: return .GET
        case .PostUser: return .POST
        case .PostSession: return .POST
        case .PostMicropost: return .POST
        case .PostRelationships: return .POST
        case .DeleteRelationships: return .DELETE
        case .PostPasswordResetEmail: return .POST
        case .UpdatePassword: return .POST
        }
    }
    
    var path: String {
        switch self {
        case .GetUser(let userId): return "/api/users/\(userId)"

        case .GetFeed(let page): return "/api/users/feed"
        case .GetAllUsers: return "/api/users"

        case .GetFollowers(let userId, let params): return "/api/users/\(userId)/followers"
        case .GetFollowing(let userId, let params): return "/api/users/\(userId)/following"
        case .GetMicroposts(let userId, let params): return "/api/users/\(userId)/microposts"

        case .PostUser: return "/api/users"
        case .PostSession: return "api/sessions"
        case .PostMicropost: return "/api/microposts/post"
        case .PostRelationships(let followedId): return "/api/relationships/\(followedId)"
        case .DeleteRelationships(let followedId): return "/api/relationships/\(followedId)"

        case .PostPasswordResetEmail: return "/api/password_resets/create"
        case .UpdatePassword: return "/api/password_resets/update"
        }
    }

    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let url = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        let keychain = Keychain(service: "nehan.Kakico")
        if let authToken = keychain["authToken"] {
            mutableURLRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        }

        switch self {
        case .PostUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .PostSession(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .GetFeed(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetAllUsers(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetFollowers(let userId, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetFollowing(let userId, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetMicroposts(let userId, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .PostPasswordResetEmail(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UpdatePassword(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
