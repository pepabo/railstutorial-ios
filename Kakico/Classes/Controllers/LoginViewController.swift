import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import KeychainAccess

class LoginViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        checkValidLoginForm()
    }
    
    // MARK: -
    @IBAction func touchLogInButton(sender: UIButton) {
        login(emailField.text, password: passwordField.text)
    }
    
    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        view.endEditing(true)
        if textField.tag == 1 {
            passwordField.becomeFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        loginButton.enabled = false
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        checkValidLoginForm()
        return true
    }
    
    func checkValidLoginForm() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        loginButton.enabled = checkPresenceField(email, password: password) && checkValidEmail(email)
    }
    
    func checkValidEmail(email: String) -> Bool{
        let regex = "^[\\w+\\-.]+@[a-z\\d\\-]+(\\.[a-z\\d\\-]+)*\\.[a-z]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(email)
    }
    
    func checkPresenceField(email: String, password: String) -> Bool{
        return !email.isEmpty && !password.isEmpty
    }
    
    // MARK: -
    func login(email: String, password: String) {
        let params = [
            "email": email,
            "password": password
        ]
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
        Alamofire.request(Router.PostSession(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                SVProgressHUD.dismiss()
                var keychain = Keychain(service: "nehan.Kakico")
                keychain["auth_token"] = json["auth_token"].stringValue
                let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FeedNavigationController") as! UIViewController
                self.presentViewController(targetViewController, animated: true, completion: nil)
            } else{
                SVProgressHUD.showErrorWithStatus(json["messages"]["authorization"].stringValue)
            }
        }
    }
    
    func activatePlease() {
        let alert = UIAlertController(title: "", message: "Please check your email to activate your account.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
