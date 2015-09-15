import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import KeychainAccess

class LoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var activeTextField = UITextField()
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        enablePushSubmitButton()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        removeKeyboardNotifications()
        super.viewWillDisappear(animated)
    }

    // MARK: - Actions
    @IBAction func touchLogInButton(sender: UIButton) {
        login(emailField.text, password: passwordField.text)
    }
    
    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

    @IBAction func editingTextField(sender: AnyObject) {
        enablePushSubmitButton()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool{
        view.endEditing(true)
        if textField.tag == 1 {
            passwordField.becomeFirstResponder()
        }
        return false
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        enablePushSubmitButton()
        return true
    }
    
    func enablePushSubmitButton() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        loginButton.enabled = checkPresenceField(email, password: password)
    }

    func checkPresenceField(email: String, password: String) -> Bool{
        return !email.isEmpty && !password.isEmpty
    }

    // MARK: - Keyboard
    func addKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func removeKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        var txtLimit = activeTextField.frame.origin.y + activeTextField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height

        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }

    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scrollView.contentOffset.y = 0
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
                keychain["authToken"] = json["auth_token"].stringValue
                keychain["userId"] = json["user_id"].stringValue
                let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FeedNavigationController") as! UIViewController
                self.presentViewController(targetViewController, animated: true, completion: nil)
            } else{
                SVProgressHUD.showErrorWithStatus(json["messages"]["authorization"].stringValue)
            }
        }
    }
    
    func checkEmailPlease(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
