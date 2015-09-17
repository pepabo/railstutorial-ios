import Alamofire
import KeychainAccess

enum Router: URLRequestConvertible {
    static let baseURLString = "https://157.7.190.148"

    case GetUser(userId: Int)

    case GetFeed(params: Dictionary<String, AnyObject>)
    case GetAllUsers()

    case GetLatestFeed(lastUpdate: Int)
    case GetLatestMicroposts(userId: Int, lastUpdate: Int)

    case GetFollowers(userId: Int)
    case GetFollowing(userId: Int)
    case GetMicroposts(userId: Int, params: Dictionary<String, AnyObject>)

    case PostUser(params: Dictionary<String, AnyObject>)
    case PostProfile(params: Dictionary<String, AnyObject>)
    case PostSession(params: Dictionary<String, AnyObject>)
    case PostMicropost()
    
    case PostRelationships(followedId: Int)
    case DeleteRelationships(followedId: Int)

    case PostPasswordResetEmail(params: Dictionary<String, String>)
    case UpdatePassword(params: Dictionary<String, String>)

    case DeleteMicropost(micropostId: Int)

    var method: Alamofire.Method {
        switch self {
        case .GetUser: return .GET
        case .GetFeed: return .GET
        case .GetAllUsers: return .GET
        case GetLatestFeed: return .GET
        case GetLatestMicroposts: return .GET
        case .GetFollowers: return .GET
        case .GetFollowing: return .GET
        case .GetMicroposts: return .GET
        case .PostUser: return .POST
        case .PostProfile: return .POST
        case .PostSession: return .POST
        case .PostMicropost: return .POST
        case .PostRelationships: return .POST
        case .DeleteRelationships: return .DELETE
        case .PostPasswordResetEmail: return .POST
        case .UpdatePassword: return .POST
        case .DeleteMicropost: return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .GetUser(let userId): return "/api/users/\(userId)"

        case .GetFeed(let page): return "/api/users/feed"
        case .GetAllUsers: return "/api/users"

        case GetLatestFeed(let lastUpdate): return "/api/users/feed/latest/\(lastUpdate)"
        case GetLatestMicroposts(let userId, let lastUpdate): return "/api/users/\(userId)/microposts/latest/\(lastUpdate)"
                                 
        case .GetFollowers(let userId): return "/api/users/\(userId)/followers"
        case .GetFollowing(let userId): return "/api/users/\(userId)/following"
        case .GetMicroposts(let userId, let params): return "/api/users/\(userId)/microposts"

        case .PostUser: return "/api/users"
        case .PostProfile: return "/api/users/edit"
        case .PostSession: return "api/sessions"
        case .PostMicropost: return "/api/microposts/post"
        case .PostRelationships(let followedId): return "/api/relationships/\(followedId)"
        case .DeleteRelationships(let followedId): return "/api/relationships/\(followedId)"

        case .PostPasswordResetEmail: return "/api/password_resets/create"
        case .UpdatePassword: return "/api/password_resets/update"

        case .DeleteMicropost(let micropostId): return "/api/microposts/\(micropostId)"
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
        case .PostProfile(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .PostSession(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .GetFeed(let parameters):
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
