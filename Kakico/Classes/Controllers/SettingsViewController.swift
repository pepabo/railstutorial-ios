import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import KeychainAccess

class SettingsViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    private var activeTextField = UITextField()
    private var keyboardLimit: CGFloat?
    @IBOutlet weak var submitButton: UIButton!

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        initForm()
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

    @IBAction func submitSettingsForm(sender: UIButton) {
        submit(nameTextField.text, email: emailTextField.text, password: passwordTextField.text)
    }

    @IBAction func editingTextField(sender: AnyObject) {
        validateSubmitButton()
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == textFields.count {
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

    // MARK: - Keyboard Notification
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
        var navigationBarHeight = navigationController!.navigationBar.frame.size.height
        var txtLimit = activeTextField.frame.origin.y + activeTextField.frame.height + 30.0 + navigationBarHeight
        keyboardLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        if txtLimit >= keyboardLimit {
            scrollView.contentOffset.y = txtLimit - keyboardLimit!
        }
    }

    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scrollView.contentOffset.y = 0
    }

    // MARK: - API request methods
    func initForm() -> Void {
        let keychain = Keychain(service: "nehan.Kakico")
        if let userId = keychain["userId"] {
            Alamofire.request(Router.GetUser(userId: userId.toInt()!)).responseJSON { (request, response, data, error) -> Void in
                let json = JSON(data!)
                println(json)
                println(json["status"])
                if json["status"] == 200 {
                    self.nameTextField.text = json["contents"]["name"].string!
                    self.emailTextField.text = json["contents"]["email"].string!
                }
            }
        }
    }

    func submit(name: String, email: String, password: String) {
        let params = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
        Alamofire.request(Router.PostProfile(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                SVProgressHUD.showSuccessWithStatus("Edit Succeeded!", maskType: .Black)
            } else{
                let tmp = json["messages"]["user"]
                SVProgressHUD.showErrorWithStatus(json["messages"]["user"].dictionary!.values.first?.stringValue)
            }
        }
    }

    // MARK: - Helpers
    func validateSubmitButton() {
        submitButton.enabled = nameTextField.hasText() && emailTextField.hasText()
    }
}
