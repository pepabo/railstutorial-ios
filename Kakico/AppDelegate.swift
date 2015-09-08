import UIKit
import Alamofire
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let manager = Alamofire.Manager.sharedInstance
        
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .CancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .UseCredential
                    }
                }
            }
            
            return (disposition, credential)
        }

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        if url.host != nil {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let identifier = getControllerIdentifierFromURL(url)
            var initialViewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        var params = Dictionary<String, String>()
        if url.query != nil {
            params = getParamsFromURL(url)
        }
        
        println(application)
        println(url)
        println(sourceApplication)
        println(annotation)
        
        if let auth_token = params["auth_token"] {
            var keychain = Keychain(service: "nehan.Kakico")
            keychain["auth_token"] = auth_token
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    func getControllerIdentifierFromURL(url: NSURL) -> String {
        return url.host! + "NavigationController"

    }

    func getParamsFromURL(url: NSURL) -> Dictionary<String, String> {
        var params = Dictionary<String, String>()
        if let query = url.query as String! {
            for param in split(query, allowEmptySlices: true, isSeparator: { $0 == "&" }) {
                let elements = split(param, allowEmptySlices: true, isSeparator: { $0 == "=" })
                params[elements[0]] = elements[1]
            }
        }
        return params
    }
}

