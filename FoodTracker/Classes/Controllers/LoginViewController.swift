import UIKit

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
        login()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        view.endEditing(true)
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
    func login() {
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
    }
}
