import Alamofire

class APIClient: NSObject {
    func getUser(
        userId: Int,
        onSuccess: (user: User) -> Void,
        onFailure: (error: NSHTTPURLResponse) -> Void
        ) {


    }
}