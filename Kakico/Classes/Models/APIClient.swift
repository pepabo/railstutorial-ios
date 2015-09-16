import Alamofire
import SwiftyJSON

class APIClient: NSObject {
    func getUser(
        userId: Int,
        onSuccess: (user: User) -> Void,
        onFailure: (error: NSHTTPURLResponse, messages:JSON? ) -> Void
        ) {
            Alamofire.request(Router.GetUser(userId: userId)).responseJSON { (request, response, data, error) -> Void in
                if data == nil {
                    onFailure(error: response!, messages: nil)
                } else {
                    let json = JSON(data!)
                    switch json["status"] {
                    case 200:
                        onSuccess(user: User(data: json["contents"]))
                    default:
                        onFailure(error: response!, messages: json["messages"])
                    }
                }
            }
        }
}