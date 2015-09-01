import UIKit
import Alamofire
import SVProgressHUD
       
class SignupViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.enabled = checkValidSignupForm()
    }
    
    // MARK: - Actions
    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        for textField : UITextField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        signUpButton.enabled = checkValidSignupForm()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 4 {
            textField.resignFirstResponder()
        } else {
            textFields[textField.tag].becomeFirstResponder()
        }
        return false
    }
    
    func checkValidSignupForm() -> Bool {
        return checkPresenceField() && checkValidEmail()
    }
    
    func checkValidEmail() -> Bool{
        let regex = "^[\\w+\\-.]+@[a-z\\d\\-]+(\\.[a-z\\d\\-]+)*\\.[a-z]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(emailTextField.text)
    }
    
    func checkPresenceField() -> Bool{
        var result = true
        for textField : UITextField in textFields {
            result = result && textField.hasText()
        }
        return result
    }
    
    @IBAction func SubmitSignUpForm(sender: UIButton) {
        create(nameTextField.text, email: emailTextField.text, password: passwordTextField.text, password_confirmation: confirmationTextField.text)
    }
    
    func create(name: String, email: String, password: String, password_confirmation: String) {
        let params = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation
        ]
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
        //Alamofire.request(.POST, "https://157.7.190.148/api/users", parameters: params, encoding: .JSON)
        Alamofire.request(.POST, "http://localhost:3000/api/users", parameters: params, encoding: .JSON)
            .responseJSON { (request, response, JSON, error) in
                println(JSON)
                var json = JSON as! Dictionary<String, AnyObject>
                if json["status"] as! Int == 200 {
                    SVProgressHUD.dismiss()
                    let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FeedNavigationController") as! UIViewController
                    self.presentViewController( targetViewController, animated: true, completion: nil)
                } else{
                    var messages = json["messages"] as! Dictionary<String, AnyObject>
                    var user_errors = messages["user"] as! Dictionary<String, String>
                    SVProgressHUD.showErrorWithStatus(user_errors.values.first)
                }
        }
    }
}