import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet weak var nameTexeField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet var textFields: [UITextField]!
    
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
}
