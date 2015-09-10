import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import KeychainAccess

class ProfileEditViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
                                                  
    // MARK: - Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    private var activeTextField = UITextField()
    private var keyboardLimit: CGFloat?
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        for textField : UITextField in textFields {
            textField.resignFirstResponder()
        }
    }

    @IBAction func submitProfileEditForm(sender: UIButton) {
        submit(nameTextField.text, email: emailTextField.text, password: passwordTextField.text, password_confirmation: confirmationTextField.text)
    }
    
    // MARK: - helpers
    
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
    
    func submit(name: String, email: String, password: String, password_confirmation: String) {
        let params = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation
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

    // MARK: - UITextFieldDelegate

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
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
        var navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
        var txtLimit = activeTextField.frame.origin.y + activeTextField.frame.height + 30.0 + navigationBarHeight
        keyboardLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        if txtLimit >= keyboardLimit {
            scrollView.contentOffset.y = txtLimit - keyboardLimit!
        }
    }

    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scrollView.contentOffset.y = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
