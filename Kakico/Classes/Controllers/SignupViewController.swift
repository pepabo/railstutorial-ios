import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class SignupViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    private var activeTextField = UITextField()
    private var keyboardLimit: CGFloat?
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.enabled = checkValidSignupForm()
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
    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        for textField : UITextField in textFields {
            textField.resignFirstResponder()
        }
    }

    @IBAction func SubmitSignUpForm(sender: UIButton) {
        create(nameTextField.text, email: emailTextField.text, password: passwordTextField.text, password_confirmation: confirmationTextField.text)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        signUpButton.enabled = checkValidSignupForm()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 4 {
            textField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
            for field : UITextField in textFields {
                if field.tag == textField.tag + 1 {
                    field.becomeFirstResponder()
                }
            }
        }
        return false
    }
    
    func checkValidSignupForm() -> Bool {
        return checkPresenceField()
    }
    
    func checkPresenceField() -> Bool{
        var result = true
        for textField : UITextField in textFields {
            result = result && textField.hasText()
        }
        return result
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
        keyboardLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        if txtLimit >= keyboardLimit {
            scrollView.contentOffset.y = txtLimit - keyboardLimit!
        }

    }

    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scrollView.contentOffset.y = 0
    }

    // MARK: -
    func create(name: String, email: String, password: String, password_confirmation: String) {
        let params = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation
        ]
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
        Alamofire.request(Router.PostUser(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                SVProgressHUD.dismiss()
                let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                self.presentViewController(targetViewController, animated: true, completion: nil)
                targetViewController.activatePlease()
            } else{
                let tmp = json["messages"]["user"]
                SVProgressHUD.showErrorWithStatus(json["messages"]["user"].dictionary!.values.first?.stringValue)
            }
        }
    }
}